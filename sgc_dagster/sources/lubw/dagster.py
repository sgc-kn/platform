from . import lib
from ... import secrets
from ... import quantumleap
from dagster import graph, job, op
from dagster import DynamicOut, DynamicOutput
from dagster import RetryPolicy, Jitter, Backoff
from datetime import datetime, timedelta, timezone
import dateutil

service = "nodered3"

@op( out = DynamicOut(lib.Component) )
def components():
    for c in lib.components:
        yield DynamicOutput(c, mapping_key=c.name)

@op
def last_start(context, component: lib.Component) -> tuple[lib.Component, datetime]:
    # this should probably be a dagster resource?
    ql = quantumleap.Client(service)

    eid = lib.raw_entity_id(component)
    try:
        o = ql.get_entity(eid)
        start = dateutil.parser.isoparse(o['startZeit'])
    except quantumleap.HTTPStatusError as e:
        start = datetime(1990, 1, 1, 0, 0, tzinfo=timezone.utc)
        start = datetime(2023, 1, 1, 0, 0, tzinfo=timezone.utc)
        # start = datetime(2024, 1, 1, 0, 0, tzinfo=timezone.utc)

    context.log.info(f"last start: {start}")

    return (component, start)

@op( out = DynamicOut(tuple[lib.Component, datetime, datetime]) )
def batches( states: list[tuple[lib.Component, datetime]] ):
    # lubw returns at most 100 measurements per request
    # we're requesting hourly data
    for component, start in states:
        end = datetime.now(timezone.utc)
        step = timedelta(hours = 100)
        b_start = start
        b_end = b_start + step - timedelta(seconds = 1)
        while b_start < end:
            c_key = component.name
            d_key = b_start.astimezone(timezone.utc).strftime("%Y%m%d_%H%M%S")
            batch = (component, b_start, min(end, b_end))
            yield DynamicOutput(batch, mapping_key=f"{c_key}_{d_key}")
            b_start += step
            b_end += step


@op(retry_policy = RetryPolicy(
    max_retries = 7,
    delay = 2,
    backoff = Backoff.EXPONENTIAL,
    jitter = Jitter.FULL,
    ))
def sync(batch: tuple[lib.Component, datetime, datetime]) -> None:
    component, start, end = batch

    # this should probably be a dagster resource?
    lubw = lib.Client(
            username = secrets.get('lubw', 'username'),
            password = secrets.get('lubw', 'password')
            )

    data = lubw.get(component, start, end)

    assert 'nextLink' not in data, "excessive batch size"

    entity_updates = lib.entity_updates(component, data)

    if len(entity_updates) > 0:
        # this should probably be a dagster resource?
        ql = quantumleap.Client(service)

        ql.post_entity_updates(entity_updates)

@job(name = "lubw_sync")
def job():
    batches(components().map(last_start).collect()).map(sync)
