from dataclasses import dataclass
from datetime import datetime, timezone
import dateutil.parser
import deltalake
import httpx
import pandas
import pyarrow
import urllib
import os

lubw_url = "https://mersyzentrale.de/www/Datenweitergabe/Konstanz/data.php"
lubw_start_date = datetime(1990, 9, 4, 0, 0)


@dataclass(frozen=True)
class Component:
    name: str
    remote: str


o3 = Component("o3", "O3")
no2 = Component("no2", "NO2")
pm10 = Component("pm10", "PM10")
pm25 = Component("pm25", "PM2,5")

components = [o3, no2, pm10, pm25]


class Client:
    def __init__(self, *args):
        auth = httpx.DigestAuth(
                username=os.environ['LUBW_USER'],
                password=os.environ['LUBW_PASSWORD'],
                )
        self._httpx = httpx.Client(auth=auth)

    def params(self, component: Component, start: datetime, end: datetime):
        return dict(
            komponente=component.remote,
            von=start.isoformat(),
            bis=end.isoformat(),
        )

    def get_with_params(self, params):
        r = self._httpx.get(
            lubw_url,
            params=params,
            headers=dict(Accept="application/json"),
            timeout=30,  # default 5s was too small
        )
        r.raise_for_status()
        return r.json()

    def get(self, *args, **kwargs):
        p = self.params(*args, **kwargs)
        return self.get_with_params(p)


def params_of_nextLink(lnk):
    parsed = urllib.parse.urlparse(lnk)
    return {k: v for k, v in urllib.parse.parse_qsl(parsed.query)}


def start_end_of_params(params):
    start = dateutil.parser.isoparse(params["von"])
    end = dateutil.parser.isoparse(params["bis"])
    return start, end


def start_end_of_nextLink(lnk):
    return start_end_of_params(params_of_nextLink(lnk))


def raw_entity_id(component):
    return f"urn:raw:lubw:konstanz:{component.name}"


def entity_updates_gen(component, lubw_json):
    raw_id = raw_entity_id(component)
    now = datetime.now(timezone.utc).isoformat()
    for mw in sorted(lubw_json["messwerte"], key=lambda x: x["startZeit"]):
        if mw["wert"] is None:
            continue
        else:
            yield dict(
                id=raw_id,
                type="raw_lubw",
                time_index=dict(value=mw["startZeit"]),
                dateProcessed=dict(value=now),
                startZeit=dict(value=mw["startZeit"]),
                endZeit=dict(value=mw["endZeit"]),
                wert=dict(value=mw["wert"]),
                station=dict(value=lubw_json["station"], type="TextUnrestricted"),
                komponente=dict(value=lubw_json["komponente"], type="TextUnrestricted"),
            )


def entity_updates(*args):
    return list(entity_updates_gen(*args))


def row_gen(component, lubw_json):
    for mw in sorted(lubw_json["messwerte"], key=lambda x: x["startZeit"]):
        if mw["wert"] is None:
            continue
        else:
            yield dict(
                station=lubw_json["station"],
                startZeit=mw["startZeit"],
                endZeit=mw["endZeit"],
                component=component.name,
                component_human=lubw_json["komponente"],
                wert=mw["wert"],
            )


def dataframe(*args):
    df = pandas.DataFrame(row_gen(*args))
    df = df.assign(startZeit=pandas.to_datetime(df.startZeit, utc=True))
    df = df.assign(endZeit=pandas.to_datetime(df.endZeit, utc=True))
    return df


delta_table = f's3://{os.environ['S3_DATA_BUCKET']}/'
delta_table += 'lubw/measurements-v0'
delta_storage_options = {
    'access_key_id': os.environ['S3_DATA_KEY_ID'],
    'secret_access_key': os.environ['S3_DATA_SECRET'],
    'endpoint': os.environ['S3_DATA_ENDPOINT'],
}


def delta_upload(df):
    arrow = pyarrow.Table.from_pandas(df, preserve_index=False)
    deltalake.write_deltalake(
        delta_table,
        arrow,
        mode="append",
        storage_options = delta_storage_options
    )
