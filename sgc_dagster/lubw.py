from . import secrets
import dagster
import datetime
import httpx
import urllib
import re

lubw_url = "https://mersyzentrale.de/www/Datenweitergabe/Konstanz/data.php"
lubw_start_date = datetime.datetime(1990, 9, 4, 0, 0)

udp_domain = "udp-kn.de"
udp_realm = "konstanz"

fiware_service = "nodered3"

def get_token():
    r = httpx.request(
        'POST',
        f'https://idm.{udp_domain}/auth/realms/{udp_realm}/protocol/openid-connect/token',
        data=dict(
            client_id = secrets.get('udp', 'client_id'),
            client_secret = secrets.get('udp', 'client_secret'),
            grant_type = 'password',
            username=secrets.get('udp', 'username'),
            password=secrets.get('udp', 'password'),
            scope = "api:read api:write api:delete",
        )
    )
    r.raise_for_status()
    return r.json()['access_token']

def _post_entity_update_batch(lst):
    assert len(lst) <= 256
    r = httpx.request(
        'POST',
        f'https://apim.{udp_domain}/gateway/quantumleap/v2/notify',
        headers = {
            'Authorization' : f"Bearer {get_token()}",
            'Fiware-Service' : fiware_service,
            'Fiware-ServicePath' : '/',
            'Fiware-TimeIndex-Attribute' : 'time_index',
        },
        json = dict(
            data = lst
        ),
    )
    r.raise_for_status()
    return r

def post_entity_updates(lst):
    print(f"Upload {len(lst)} entity updates to UDP ...")
    batch_size = 256
    if len(lst) <= batch_size:
        _post_entity_update_batch(lst)
    else:
        for i in range(0, len(lst), batch_size):
            _post_entity_update_batch(lst[i:i+batch_size])

def _get_data(params):
    auth = httpx.DigestAuth(
            username=secrets.get('lubw', 'username'),
            password=secrets.get('lubw', 'password'),
            )
    client = httpx.Client(auth=auth)
    r = client.get(
            lubw_url,
            params = params,
            headers=dict(Accept="application/json")
            )
    r.raise_for_status()
    return r.json()

@dagster.op
def get_data(context,
             component: str,
             start: datetime.datetime,
             end: datetime.datetime):
    params = dict(
            komponente=component, # this is required
            von=start.isoformat(), # this is required
            bis=end.isoformat(), # it works w/o bis
            )
    context.log.info(f"get data for params {params}")
    data = _get_data(params)
    context.log.info(f"rcv n={len(data['messwerte'])} for {params}")
    data['component'] = component
    return data

    # logic to continue if return was capped
    messwerte = data['messwerte']
    while 'nextLink' in data.keys():
        parsed = urllib.parse.urlparse(data['nextLink'])
        params = dict()
        for k, v in urllib.parse.parse_qsl(parsed.query):
            params[k] = v
        context.log.info(f"get additional data {params}")
        data = _get_data(params)
        context.log.info(f"rcv n={len(data['messwerte'])} for {params}")
        messwerte = messwerte + data['messwerte']
    data['messwerte'] = messwerte
    data['component'] = component
    return data

@dagster.op
def o3() -> str:
    return "O3"

@dagster.op
def no2() -> str:
    return "NO2"

@dagster.op
def pm10() -> str:
    return "PM10"

@dagster.op
def pm25() -> str:
    return "PM2,5"

@dagster.op
def von() -> datetime.datetime:
    return datetime.datetime.now() - datetime.timedelta(days=1)
    return lubw_start_date

@dagster.op
def bis() -> datetime.datetime:
    return datetime.datetime.now()

@dagster.op
def build_observations(context, lubw_json):
    component = re.sub(r'\W+', '', lubw_json['component']).lower()
    entity_id = f"urn:raw:lubw:konstanz:" + component
    now = datetime.datetime.now().isoformat()

    observations = []
    for mw in lubw_json['messwerte']:
        if mw['wert'] is None:
            continue

        o = dict(
                id = entity_id,
                type = "raw_lubw",
                time_index = dict(value = mw['startZeit']),
                date_processed = dict(value = now),
                startZeit = dict(value = mw['startZeit']),
                endZeit = dict(value = mw['endZeit']),
                wert = dict(value = mw['wert']),
                komponente = dict(value = lubw_json['komponente'],
                                  type="TextUnrestricted"),
                )
        observations.append(o)

    context.log.info(f"create {len(observations)} observations")
    return observations

@dagster.op
def upload(context, observations):
    context.log.info(f"upload {len(observations)} observations")
    post_entity_updates(observations)

@dagster.op
def concat(a, b, c ,d):
    return a + b + c + d

@dagster.job
def lubw():
    avon = von()
    abis = bis()

    lst = concat(
            build_observations(get_data(o3(), avon, abis)),
            build_observations(get_data(no2(), avon, abis)),
            build_observations(get_data(pm10(), avon, abis)),
            build_observations(get_data(pm25(), avon, abis))
            )

    upload(lst)
