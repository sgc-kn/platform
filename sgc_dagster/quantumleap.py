from . import secrets
import httpx
import time
import tqdm

udp_domain = "udp-kn.de"
udp_realm = "konstanz"

HTTPStatusError = httpx.HTTPStatusError

class Client():
    def __init__(self, fiware_service: str):
        self._service = fiware_service

    def get_token(self, scope="read"):
        r = httpx.request(
            'POST',
            f'https://idm.{udp_domain}/auth/realms/{udp_realm}/protocol/openid-connect/token',
            data=dict(
                client_id = secrets.get('udp', 'client_id'),
                client_secret = secrets.get('udp', 'client_secret'),
                grant_type = 'password',
                username=secrets.get('udp', 'username'),
                password=secrets.get('udp', 'password'),
                scope = f"api:{scope}",
            )
        )
        r.raise_for_status()
        return r.json()['access_token']

    def get_entity(self, entity_id):
        r = httpx.request(
            'GET',
            f'https://apim.{udp_domain}/gateway/quantumleap/v2/entities/{entity_id}',
            params = { 'lastN': 1 },
            headers = {
                'Authorization' : f"Bearer {self.get_token("read")}",
                'Fiware-Service' : self._service,
                'Fiware-ServicePath' : '/',
            },
        )
        r.raise_for_status()

        # simplify json w.r.t. lastN=1
        o = r.json()
        for a in o.pop('attributes', []):
            o[a['attrName']] = a['values'][0]

        # the database column is called time_index
        o['time_index'] = o.pop('index', [None])[0]

        return o

    def _post_entity_update_batch(self, lst, *args, time_index = "time_index"):
        assert len(lst) <= 256
        r = httpx.request(
            'POST',
            f'https://apim.{udp_domain}/gateway/quantumleap/v2/notify',
            headers = {
                'Authorization' : f"Bearer {self.get_token("write")}",
                'Fiware-Service' : self._service,
                'Fiware-ServicePath' : '/',
                'Fiware-TimeIndex-Attribute' : time_index,
            },
            json = dict(
                data = lst
            ),
        )
        r.raise_for_status()
        return r

    def exponential_backoff(self, fn, *args, retries=0, **kwargs):
        for i in range(retries):
            try:
                return fn(*args, **kwargs)
            except httpx.HTTPError as e:
                d = 2 ** i
                print(f"Wait {d} seconds after HTTP error:",  e)
                time.sleep(d)
        return fn(*args, **kwargs)

    def post_entity_updates(self, lst, *args, progress=False, batch_size=256, **kwargs):
        if len(lst) <= batch_size:
            self._post_entity_update_batch(lst, *args, **kwargs)
        else:
            batches = range(0, len(lst), batch_size)
            with_progress = tqdm.tqdm(batches) if progress else batches
            for i in with_progress:
                batch = lst[i:i+batch_size]
                self.exponential_backoff(self._post_entity_update_batch, batch, *args, **kwargs)
