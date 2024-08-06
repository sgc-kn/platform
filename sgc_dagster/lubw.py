import dagster
import httpx
from . import secrets
import datetime

lubw_url = "https://mersyzentrale.de/www/Datenweitergabe/Konstanz/data.php"

@dagster.op
def get_measurements():
    komponente = 'O3'
    # TODO komponente from config/param
    # TODO start and end date as parameters
    # TODO move auth to config
    auth = httpx.DigestAuth(
            username=secrets.get('lubw', 'username'),
            password=secrets.get('lubw', 'password'),
            )
    client = httpx.Client(auth=auth)
    now = datetime.datetime.now()
    yesterday = now - datetime.timedelta(days=1)
    yesterday = datetime.datetime(1992, 3, 21, 0, 30)
    r = client.get(
            lubw_url,
            params=dict(
                komponente=komponente,
                von=yesterday.isoformat(), # this is required
                bis=now.isoformat(), # it works w/o bis
                ),
            headers=dict(Accept="application/json")
            )
    r.raise_for_status()
    return r.json()

@dagster.job
def lubw():
    get_measurements()
