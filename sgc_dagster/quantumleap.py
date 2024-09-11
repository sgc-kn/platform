from . import secrets
import httpx
import time
import tqdm

idm_base_url = "https://idm.udp-kn.de/auth/realms/konstanz"
ql_base_url = "https://apim.udp-kn.de/gateway/quantumleap"

HTTPStatusError = httpx.HTTPStatusError

class UDPAuth():
    def __init__(self, *, base_url = idm_base_url):
        self._base_url = idm_base_url

    def header(self, scope: str):
        r = httpx.request(
            'POST',
            f'{self._base_url}/protocol/openid-connect/token',
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
        token = r.json()['access_token']
        return { 'Authorization' : f"Bearer {token}" }

class DummyAuth():
    def header(self, scope: str):
        return dict()


class Client():
    def __init__(self, fiware_service: str, *, base_url = ql_base_url, auth = None):
        if auth is None:
            self._auth = UDPAuth()
        else:
            self._auth = auth

        self._base_url = base_url
        self._service = fiware_service

    def get_entity(self, entity_id):
        r = httpx.request(
            'GET',
            f'{self._base_url}/v2/entities/{entity_id}',
            params = { 'lastN': 1 },
            headers = {
                'Fiware-Service' : self._service,
                'Fiware-ServicePath' : '/',
            } | self._auth.header('read'),
        )
        r.raise_for_status()

        # simplify json w.r.t. lastN=1
        o = r.json()
        for a in o.pop('attributes', []):
            o[a['attrName']] = a['values'][0]

        # the database column is called time_index
        o['time_index'] = o.pop('index', [None])[0]

        return o

    def delete_entity_type(self, ty, *, ignore_404 = False):
        r = httpx.request(
            'DELETE',
            f'{self._base_url}/v2/types/{ty}',
            headers = {
                'Fiware-Service' : self._service,
                'Fiware-ServicePath' : '/',
            } | self._auth.header('delete'),
            timeout = 30,
        )
        if ignore_404 and r.status_code == 404:
            # type does not exist
            return
        else:
            r.raise_for_status()

    def _post_entity_update_batch(self, lst, *args, time_index = "time_index"):
        assert len(lst) <= 256
        r = httpx.request(
            'POST',
            f'{self._base_url}/v2/notify',
            headers = {
                'Fiware-Service' : self._service,
                'Fiware-ServicePath' : '/',
                'Fiware-TimeIndex-Attribute' : time_index,
            } | self._auth.header('write'),
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
