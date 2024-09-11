from . import lib
from utils import secrets
from integrations.sinks import quantumleap
from dagster import graph, job, op
from dagster import DynamicOut, DynamicOutput
from dagster import RetryPolicy, Jitter, Backoff
from dagster import ScheduleDefinition, DefaultScheduleStatus
from datetime import datetime, timedelta, timezone
import dateutil

service = "nodered3"

@op( out = DynamicOut(lib.Component) )
def components():
    for c in lib.components:
        yield DynamicOutput(c, mapping_key=c.name)

@op
def start_time(context, component: lib.Component) -> tuple[lib.Component, datetime]:
    # this should probably be a dagster resource?
    ql = quantumleap.Client(service)

    eid = lib.raw_entity_id(component)
    try:
        o = ql.get_entity(eid)
        latest = dateutil.parser.isoparse(o['endZeit'])
        context.log.info(f"last endZeit: {latest}")
        start = latest + timedelta(seconds = 1)

    except quantumleap.HTTPStatusError as e:
        raise RuntimeError(
                "entity not found; this job is suited for historic syncs"
                )

    if datetime.now(timezone.utc) - start > timedelta(days = 90):
        raise RuntimeError(
                "long sync span; this job is not suited for long-term syncs"
                )

    return (component, start)

@op( out = DynamicOut(tuple[lib.Component, datetime, datetime]) )
def batches(context, states: list[tuple[lib.Component, datetime]] ):
    # lubw returns at most 100 measurements per request
    # we're requesting hourly data
    n = 0
    end = datetime.now(timezone.utc)
    for component, start in states:
        step = timedelta(hours = 100)
        b_start = start
        b_end = b_start + step
        while b_start < end:
            c_key = component.name
            d_key = b_start.astimezone(timezone.utc).strftime("%Y%m%d_%H%M%S")
            batch = (component, b_start, min(end, b_end))
            yield DynamicOutput(batch, mapping_key=f"{c_key}_{d_key}")
            b_start += step
            b_end += step
            n += 1

    context.log.info(f"{n} batches")

# -- SQL for checking batches w.r.t overlap and gaps:
# -- Attention: the source seems to be incomplete on its own.
# SELECT date_processed, MIN(time_index) as min, MAX(time_index), COUNT(*)
# FROM mtnodered3.etraw_lubw
# WHERE entity_id LIKE '%:o3'
# GROUP BY date_processed ORDER BY min ASC;

@op(retry_policy = RetryPolicy(
    max_retries = 7,
    delay = 2,
    backoff = Backoff.EXPONENTIAL,
    jitter = Jitter.FULL,
    ))
def sync(context, batch: tuple[lib.Component, datetime, datetime]) -> None:
    component, start, end = batch

    # this should probably be a dagster resource?
    lubw = lib.Client(
            username = secrets.get('lubw', 'username'),
            password = secrets.get('lubw', 'password')
            )

    data = lubw.get(component, start, end)

    assert 'nextLink' not in data, "excessive batch size"

    entity_updates = lib.entity_updates(component, data)

    n = len(entity_updates)
    if n > 0:
        # this should probably be a dagster resource?
        ql = quantumleap.Client(service)

        context.log.info(f"post {n} entity updates to QL")
        ql.post_entity_updates(entity_updates)
    else:
        context.log.info("no entity updates; skip QL post")

@job(name = "lubw_sync")
def job():
    batches(components().map(start_time).collect()).map(sync)

schedule = ScheduleDefinition(
    job=job,
    cron_schedule="29 */4 * * *", # every 4 hours
    #  default_status=DefaultScheduleStatus.RUNNING,
)

from utils.dagster import registry as dagster_registry
dagster_registry.register(jobs = [job], schedules = [schedule])
