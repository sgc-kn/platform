from . import lib
from ... import secrets
from ... import quantumleap
from dagster import graph, job, op
from dagster import DynamicOut, DynamicOutput
from datetime import datetime, timezone
import dateutil

service = "nodered3"

@op( out = DynamicOut(lib.Component) )
def components():
    for c in lib.components:
        yield DynamicOutput(c, mapping_key=c.name)

@op
def start_time(context, component: lib.Component) -> datetime:
    # this should probably be a dagster resource?
    ql = quantumleap.Client(service)

    eid = lib.raw_entity_id(component)
    try:
        o = ql.get_entity(eid)
        start = dateutil.parser.isoparse(o['endZeit'])
    except quantumleap.HTTPStatusError as e:
        start = datetime(1990, 1, 1, 0, 0)

    context.log.info(f"{start}")

    return start

@op(out = DynamicOut() )
def get(component, start):
    end = datetime.now()

    # this should probably be a dagster resource?
    lubw = lib.Client(
            username = secrets.get('lubw', 'username'),
            password = secrets.get('lubw', 'password')
            )

    def key(dt):
        return dt.astimezone(timezone.utc).strftime("%Y%m%d_%H%M%S")

    data = lubw.get(component, start, end)
    yield DynamicOutput(data, mapping_key=key(start))

    while 'nextLink' in data:
        start, _ = lib.start_end_of_nextLink(data['nextLink'])
        data = lubw.get(component, start, end)
        yield DynamicOutput(data, mapping_key=key(start))

@op
def build_entity_updates(component, lubw_json):
    return lib.entity_updates(component, lubw_json)

@op
def post(entity_updates):
    # this should probably be a dagster resource?
    ql = quantumleap.Client(service)

    n = len(entity_updates)
    if n > 0:
        ql.post_entity_updates(entity_updates)

@graph
def sync(component):
    ( get(component, start_time(component))
     .map(lambda x: build_entity_updates(component, x))
     .map(post)
    )

@job
def job():
    components().map(sync)
