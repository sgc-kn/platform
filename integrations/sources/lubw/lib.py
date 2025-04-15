from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from tqdm import tqdm
import dateutil.parser
import deltalake
import httpx
import pandas
import pyarrow
import pytz
import urllib
import os

lubw_baseurl = "https://mersyzentrale.lubw.de/www/Datenweitergabe/Konstanz/"
lubw_url = lubw_baseurl + "data.php"
lubw_documentation = lubw_baseurl + "Schnittstellen-Dokumentation.pdf"
lubw_start_date = datetime(1990, 9, 4, 0, 0)

MEZ = pytz.timezone('CET')

def is_timezone_aware(dt):
    return dt.tzinfo is not None and dt.utcoffset() is not None

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
    def __init__(self, *args, retries=1):
        auth = httpx.DigestAuth(
                username=os.environ['LUBW_USER'],
                password=os.environ['LUBW_PASSWORD'],
                )
        trsp = httpx.HTTPTransport(retries=retries)
        self._httpx = httpx.Client(auth=auth, transport=trsp)

    def params(self, component: Component, start: datetime, end: datetime):
        if not is_timezone_aware(start):
            raise ValueError("start must be timezone aware")
        if not is_timezone_aware(end):
            raise ValueError("end must be timezone aware")

        # API expects MEZ times w/o timezone
        start = start.astimezone(MEZ).replace(tzinfo=None)
        end = end.astimezone(MEZ).replace(tzinfo=None)

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


def time_batches(start, end):
    n = 0
    step = timedelta(hours=100)
    b_start = start
    b_end = b_start + step
    while b_start < end:
        yield (b_start, min(end, b_end))
        b_start += step
        b_end += step
        n += 1

def component_time_batches(*args):
    for (start, end) in time_batches(*args):
        for c in components:
            yield (c, start, end)

### Delta Table

delta_table = f's3://{os.environ['S3_DATA_BUCKET']}/'
delta_table += 'lubw/measurements-v0'
delta_storage_options = {
    'access_key_id': os.environ['S3_DATA_KEY_ID'],
    'secret_access_key': os.environ['S3_DATA_SECRET'],
    'endpoint': os.environ['S3_DATA_ENDPOINT'],
}

def deltatable():
    return deltalake.DeltaTable(delta_table, storage_options = delta_storage_options)


def load_measurements(start, end, *, progress=True):
    batches = component_time_batches(start, end)
    batches = list(batches)
    if progress:
        batches = tqdm(batches)

    client = Client(retries=7)
    data = { c: [] for c in components }

    for (component, b_start, b_end) in batches:
        json = client.get(component, b_start, b_end)
        data[component].extend(json['messwerte'])

    return data


def build_dataframe(data):
    columns = dict()
    for component in components:
        messwerte = data[component]

        if len(messwerte) == 0:
            # early years do not have pm25
            continue

        df = pandas.DataFrame(messwerte)
        df = df.assign(startZeit=pandas.to_datetime(df.startZeit, utc=True))
        df = df.assign(endZeit=pandas.to_datetime(df.endZeit, utc=True))

        # avoid merging on multi-index; endZeit is redundant; drop here + restore later
        assert all(df.startZeit + timedelta(hours = 1) == df.endZeit)
        del df['endZeit']

        series = df.set_index('startZeit').wert
        series = series.dropna()

        columns[component.name] = series

    if len(columns) == 0:
        raise ValueError('data does not contain measurements')

    df = pandas.concat(columns, axis=1).reset_index()

    # restore endZeit
    df['endZeit'] = df.startZeit + timedelta(hours = 1)

    # reorder columns
    df = df.reindex(columns = ['startZeit', 'endZeit'] + list(columns.keys()))

    return df


def upload_dataframe(df, *, mode="append", schema_mode="merge", dt=None):
    arrow = pyarrow.Table.from_pandas(df, preserve_index=False)
    if dt is None:
        deltalake.write_deltalake(
            delta_table,
            arrow,
            mode=mode,
            schema_mode=schema_mode,
            storage_options = delta_storage_options
        )
    else:
        deltalake.write_deltalake(
            dt,
            arrow,
            mode=mode,
            schema_mode=schema_mode,
        )
