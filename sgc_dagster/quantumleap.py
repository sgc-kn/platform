from . import secrets
import httpx

udp_domain = "udp-kn.de"
udp_realm = "konstanz"

fiware_service = "nodered3"

class Client():
    def __init__(self, fiware_service: str):
        self._service = fiware_service

    def get_token(self):
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

    def _post_entity_update_batch(self, lst, *args, time_index = "time_index"):
        assert len(lst) <= 256
        r = httpx.request(
            'POST',
            f'https://apim.{udp_domain}/gateway/quantumleap/v2/notify',
            headers = {
                'Authorization' : f"Bearer {get_token()}",
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

    def post_entity_updates(self, lst, *args, **kwargs):
        print(f"Upload {len(lst)} entity updates to UDP ...")
        batch_size = 256
        if len(lst) <= batch_size:
            _post_entity_update_batch(lst, *args, **kwargs)
        else:
            for i in range(0, len(lst), batch_size):
                batch = lst[i:i+batch_size]
                _post_entity_update_batch(batch, *args, **kwargs)
