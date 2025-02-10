import html.parser
import httpx
import io
import pandas
import zipfile


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
                for c in ["MESS_DATUM", "MESS_DATUM_BEGINN", "MESS_DATUM_ENDE"]:
                    if c not in df.columns:
                        continue
                    if int(df[c][0]) <= 99999999:
                        df[c] = pandas.to_datetime(df[c], format="%Y%m%d")
                    elif int(df[c][0]) <= 9999999999:
                        df[c] = pandas.to_datetime(df[c], format="%Y%m%d%H")
                    else:
                        raise ValueError((name, c, df[c][0]))
                tables["data"] = df
                continue

            if name.startswith("Metadaten_Parameter"):
                df = pandas.read_csv(zf.open(name), **kwargs, skipfooter=2)
                for c in ["Von_Datum", "Bis_Datum"]:
                    df[c] = pandas.to_datetime(df[c], format="%Y%m%d")
                tables["meta_parameter"] = df

                continue

            if name.startswith("Metadaten_Fehlwerte"):
                df = pandas.read_csv(zf.open(name), **kwargs, skipfooter=1)
                for c in ["Von_Datum", "Bis_Datum"]:
                    try:
                        df[c] = pandas.to_datetime(df[c], format="%d.%m.%Y-%H:%M")
                    except ValueError:
                        pass

                    df[c] = pandas.to_datetime(df[c], format="%d.%m.%Y")
                tables["meta_missing_values"] = df
                continue

            if name.startswith("Metadaten_Fehldaten"):
                continue

            if name.startswith("Metadaten_Geraete"):
                continue

            if name.startswith("Metadaten_Geographie"):
                df = pandas.read_csv(zf.open(name), **kwargs)
                df = df.rename(
                    columns={"von_datum": "Von_Datum", "bis_datum": "Bis_Datum"}
                )
                for c in ["Von_Datum", "Bis_Datum"]:
                    df[c] = pandas.to_datetime(df[c], format="%Y%m%d")
                tables["meta_geo"] = df
                continue

            if name.startswith("Metadaten_Stationsname_Betreibername"):
                lns = zf.open(name).read().splitlines()
                split_on = lns.index(b"")

                df = pandas.read_csv(zf.open(name), **kwargs, nrows=split_on - 1)
                for c in ["Von_Datum", "Bis_Datum"]:
                    df[c] = pandas.to_datetime(df[c], format="%Y%m%d")
                tables["meta_name"] = df

                df = pandas.read_csv(
                    zf.open(name), **kwargs, skiprows=split_on, skipfooter=1
                )
                for c in ["Von_Datum", "Bis_Datum"]:
                    df[c] = pandas.to_datetime(df[c], format="%Y%m%d")
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

    return tables
