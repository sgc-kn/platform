import httpx
import json
import sys
import time

# helper function; exit on http error


def req(*args, **kwargs):
    try:
        r = httpx.request(*args, **kwargs)
        r.raise_for_status()
    except httpx.HTTPError as e:
        print(e)
        print(r.text)
        sys.exit(1)

    return r


# prepare table

stmts = [
    "DROP SCHEMA IF EXISTS postgrest_ds0 CASCADE",
    """
        CREATE TABLE postgrest_ds0.table0 (
          time timestamptz,
          value double precision
        );
        """,
    "SELECT create_hypertable('postgrest_ds0.table0', 'time')",
]

req(
    "POST",
    "http://localhost:8000/api/rpc/execute_many",
    json=dict(statements = stmts),
)

time.sleep(1)

# post data as csv

data = """time,value
2023-01-01 00:00:00+00,100.0
2023-01-01 01:00:00+00,101.5
2023-01-01 02:00:00+00,102.2
2023-01-01 03:00:00+00,103.9
2023-01-01 04:00:00+00,105.1
2023-01-01 05:00:00+00,106.7
2023-01-01 06:00:00+00,108.0
2023-01-01 07:00:00+00,109.4
2023-01-01 08:00:00+00,110.8
2023-01-01 09:00:00+00,112.3
2023-01-01 10:00:00+00,113.7
2023-01-01 11:00:00+00,115.1
2023-01-01 12:00:00+00,116.5
2023-01-01 13:00:00+00,118.0
2023-01-01 14:00:00+00,119.4
2023-01-01 15:00:00+00,120.7
2023-01-01 16:00:00+00,122.1
2023-01-01 17:00:00+00,123.4
2023-01-01 18:00:00+00,124.8
2023-01-01 19:00:00+00,126.2
"""

req(
    "POST",
    "http://localhost:8000/api/table0",
    content=data,
    headers={"Content-Type": "text/csv", "Content-Profile": "postgrest_ds0"},
)

# post data as json

data = [
    dict(time="2023-01-01 20:00:00+00", value=101.8),
    dict(time="2023-01-01 21:00:00+00", value=104.7),
]

req(
    "POST",
    "http://localhost:8000/api/table0",
    headers={"Content-Profile": "postgrest_ds0"},
    json=data,
)

# read some values from the end of the table as json

r = req(
    "GET",
    "http://localhost:8000/api/table0",
    params=dict(time="gte.2023-01-01 17:00:00+00"),
    headers={"Accept-Profile": "postgrest_ds0"},
)
print(json.dumps(r.json(), indent=2))

# read some values from the top of the table as csv

r = req(
    "GET",
    "http://localhost:8000/api/table0",
    params=dict(time="lte.2023-01-01 04:00:00+00"),
    headers={"Accept": "text/csv", "Accept-Profile": "postgrest_ds0"},
)
print(r.text)
