# platform: load=true

from . import lib
from dagster import DynamicOut, DynamicOutput
from dagster import MonthlyPartitionsDefinition
from dagster import MultiPartitionsDefinition
from dagster import RetryPolicy, Jitter, Backoff
from dagster import StaticPartitionsDefinition
from dagster import graph_asset, op
from dagster import Definitions
from datetime import datetime, timedelta, timezone
from typing import Any
import pandas

partition = MonthlyPartitionsDefinition(
    start_date="2008-01-01",
    timezone="Etc/UCT",
    end_offset=1,  # include running month
)

@op(out=DynamicOut(tuple[lib.Component, datetime, datetime]))
def batches(context):
    # lubw returns at most 100 measurements per request
    # we're requesting hourly data
    # this splits the partition into batches of 100 hours

    start = datetime.strptime(context.partition_key, "%Y-%m-%d")
    start = start.replace(tzinfo=timezone.utc)

    # first day of next month
    end = (start + timedelta(days=32)).replace(day=1)

    # cap this on current datetime
    now = datetime.now(timezone.utc)
    end = min(end, now)

    n = 0
    step = timedelta(hours=100)
    for component in lib.components:
        b_start = start
        b_end = b_start + step
        while b_start < end:
            dkey = b_start.strftime("%Y%m%d_%H%M")
            ckey = component.name
            batch = (component, b_start, min(end, b_end))
            yield DynamicOutput(batch, mapping_key=f"{dkey}_{ckey}")
            b_start += step
            b_end += step
            n += 1

    context.log.info(f"start {start} | end {end} | {n} batches")


@op(
    retry_policy=RetryPolicy(
        max_retries=7,
        delay=2,
        backoff=Backoff.EXPONENTIAL,
        jitter=Jitter.FULL,
    ),
)
def get(context, batch: tuple[lib.Component, datetime, datetime]):
    component, start, end = batch

    lubw = lib.Client()

    data = lubw.get(component, start, end)

    assert "nextLink" not in data, "excessive batch size"

    context.log.info(f'got {len(data['messwerte'])} observations')

    return (component, data)


def dataframe(batched_data) -> pandas.DataFrame:
    dfs = [lib.dataframe(c, d) for c, d in batched_data if len(d["messwerte"]) > 0]
    df = pandas.concat(dfs)
    return df


@op
def upload(context, batched_data):
    df = dataframe(batched_data)
    context.log.info(f'uploading {len(df)} rows')
    lib.delta_upload(df)


@graph_asset(partitions_def=partition)
def lubw_backfill():
    batched_data = batches().map(get).collect()
    return upload(batched_data)


defs = Definitions(assets=[lubw_backfill])

from utils.dagster import registry as dagster_registry

dagster_registry.register(defs)
