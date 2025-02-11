import html.parser
import httpx
import io
import math
import pandas
import zipfile
from datetime import timedelta


class LinkParser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            for attr in attrs:
                if attr[0] == "href":
                    self.links.append(attr[1])


def list_zip_files(url, prefix):
    r = httpx.get(url)
    r.raise_for_status()

    p = LinkParser()
    p.feed(r.text)
    return [x for x in p.links if x.startswith(prefix) and x.endswith(".zip")]


def parse_integer_datetime(df, column, *, incr=False):
    if math.isnan(float(df[column][0])):
        return pandas.to_datetime([None] * len(df[column]))
    elif int(df[column][0]) <= 99999999:
        v = pandas.to_datetime(df[column], format="%Y%m%d")
        if incr:
            return v + timedelta(days=1)
        else:
            return v
    elif int(df[column][0]) <= 9999999999:
        v = pandas.to_datetime(df[column], format="%Y%m%d%H")
        if incr:
            return v + timedelta(hours=1)
        else:
            return v
    else:
        raise ValueError((column, df[column][0]))


def read_tables_from_zip(file):
    if isinstance(file, httpx.Response):
        file = io.BytesIO(file.content)

    tables = dict()
    kwargs = dict(
        dtype="str",
        encoding="iso-8859-1",
        engine="python",
        sep=r"\s*;\s*",
    )

    # read csv and metadata as DataFrame from zip file
    with zipfile.ZipFile(file, "r") as zf:
        for name in zf.namelist():
            if not name.endswith(".txt"):
                continue

            if name.startswith("produkt_"):
                df = pandas.read_csv(zf.open(name), **kwargs)
                if "MESS_DATUM_BEGINN" in df.columns:
                    df["MESS_DATUM_BEGINN"] = parse_integer_datetime(
                        df, "MESS_DATUM_BEGINN")
                    df["MESS_DATUM_ENDE"] = parse_integer_datetime(
                        df, "MESS_DATUM_ENDE", incr=True)
                else:
                    df["MESS_DATUM"] = parse_integer_datetime(df, "MESS_DATUM")

                tables["data"] = df
                continue

            if name.startswith("Metadaten_Parameter"):
                df = pandas.read_csv(zf.open(name), **kwargs, skipfooter=2)
                df['Von_Datum'] = parse_integer_datetime(df, 'Von_Datum')
                df['Bis_Datum'] = parse_integer_datetime(
                    df, 'Bis_Datum', incr=1)
                tables["meta_parameter"] = df

                continue

            if name.startswith("Metadaten_Fehlwerte"):
                df = pandas.read_csv(zf.open(name), **kwargs, skipfooter=1)
                for c in ["Von_Datum", "Bis_Datum"]:
                    try:
                        df[c] = pandas.to_datetime(
                            df[c], format="%d.%m.%Y-%H:%M")
                        if c == "Bis_Datum":
                            df[c] += timedelta(minutes=1)
                    except ValueError:
                        pass

                    df[c] = pandas.to_datetime(df[c], format="%d.%m.%Y")
                    if c == "Bis_Datum":
                        df[c] += timedelta(days=1)
                tables["meta_missing_values"] = df
                continue

            if name.startswith("Metadaten_Fehldaten"):
                continue

            if name.startswith("Metadaten_Geraete"):
                continue

            if name.startswith("Metadaten_Geographie"):
                df = pandas.read_csv(zf.open(name), **kwargs)
                df = df.rename(
                    columns={"von_datum": "Von_Datum",
                             "bis_datum": "Bis_Datum"}
                )
                df['Von_Datum'] = parse_integer_datetime(df, 'Von_Datum')
                df['Bis_Datum'] = parse_integer_datetime(
                    df, 'Bis_Datum', incr=True)
                tables["meta_geo"] = df
                continue

            if name.startswith("Metadaten_Stationsname_Betreibername"):
                lns = zf.open(name).read().splitlines()
                split_on = lns.index(b"")

                df = pandas.read_csv(
                    zf.open(name), **kwargs, nrows=split_on - 1)
                df['Von_Datum'] = parse_integer_datetime(df, 'Von_Datum')
                df['Bis_Datum'] = parse_integer_datetime(
                    df, 'Bis_Datum', incr=True)
                tables["meta_name"] = df

                df = pandas.read_csv(
                    zf.open(name), **kwargs, skiprows=split_on, skipfooter=1
                )
                df['Von_Datum'] = parse_integer_datetime(df, 'Von_Datum')
                df['Bis_Datum'] = parse_integer_datetime(
                    df, 'Bis_Datum', incr=True)
                tables["meta_operator"] = df
                continue

            raise ValueError(f"unknown table {name}")

    for name, df in tables.items():
        # fix/remove line terminator
        if "eor" in df.columns:
            assert (df["eor"] == "eor").all(), name
            del df["eor"]

        # drop empty columns
        for c in df.columns:
            if c.startswith("Unnamed"):
                assert df.loc[:, c].isnull().all(), (df, c)
                del df[c]

        # common improvements
        for c in ['STATIONS_ID', 'Stations_ID', 'Stations_id']:
            if c in df.columns:
                df[c] = pandas.to_numeric(df[c], downcast='integer')
        for c in df.columns:
            if df[c].dtype == 'O':
                try:
                    df[c] = pandas.to_numeric(df[c])
                except ValueError:
                    continue

    return tables
