# platform: load=false

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
import os

partition = MonthlyPartitionsDefinition(
    start_date="2008-01-01",
    timezone="Etc/UCT",
    end_offset=1,  # include running month
)

scope = "slh"  # sources/lubw/historic


@op(name="batches_" + scope, out=DynamicOut(tuple[lib.Component, datetime, datetime]))
def batches(context):
    # lubw returns at most 100 measurements per request
    # we're requesting hourly data
    # this splits the partition into batches of 100 hours

    start = datetime.strptime(context.partition_key, "%Y-%m-%d")
    start = start.replace(tzinfo=timezone.utc)

    # first day of next month
    end = (start + timedelta(days=32)).replace(day=1)

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
    name="get_" + scope,
    retry_policy=RetryPolicy(
        max_retries=7,
        delay=2,
        backoff=Backoff.EXPONENTIAL,
        jitter=Jitter.FULL,
    ),
)
def get(context, batch: tuple[lib.Component, datetime, datetime]):
    component, start, end = batch

    # this should probably be a dagster resource?
    lubw = lib.Client(
        username=secrets.get("lubw", "username"),
        password=secrets.get("lubw", "password"),
    )

    data = lubw.get(component, start, end)

    assert "nextLink" not in data, "excessive batch size"

    context.log.info(f'got {len(data['messwerte'])} observations')

    return (component, data)


@op
def dataframe(context, batched_data) -> pandas.DataFrame:
    dfs = [lib.dataframe(c, d) for c, d in batched_data if len(d["messwerte"]) > 0]
    df = pandas.concat(dfs)
    df.info()
    return df


@op
def save(context, df: pandas.DataFrame) -> None:
    dname = "data/sources/lubw"
    fname = dname + "/monthly_"
    fname += context.partition_key
    fname += ".csv"
    os.makedirs(dname, exist_ok=True)
    df.to_csv(fname, index=False)


@graph_asset(name="sources_lubw_monthly", partitions_def=partition)
def asset():
    df = dataframe(batches().map(get).collect())
    return save(df)


defs = Definitions(assets=[asset])

from utils.dagster import registry as dagster_registry

dagster_registry.register(defs)
