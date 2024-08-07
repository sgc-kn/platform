from dataclasses import dataclass
from datetime import datetime
import httpx

lubw_url = "https://mersyzentrale.de/www/Datenweitergabe/Konstanz/data.php"
lubw_start_date = datetime(1990, 9, 4, 0, 0)

@dataclass(frozen=True)
class Component():
    name : str
    remote : str

o3 = Component('o3', 'O3')
no2 = Component('no2', 'NO2')
pm10 = Component('pm10', 'PM10')
pm25 = Component('pm25', 'PM2,5')

class Client():
    def __init__(self, *args, username: str, password: str):
        auth = httpx.DigestAuth(username=username, password=password)
        self._httpx = httpx.Client(auth=auth)

    def params(self, component: Component, start: datetime, end: datetime):
        return dict(
                komponente = component.remote,
                von = start.isoformat(),
                bis = end.isoformat(),
                )

    def get_with_params(self, params):
        r = self._httpx.get(
                lubw_url,
                params = params,
                headers=dict(Accept="application/json")
                )
        r.raise_for_status()
        return r.json()

    def get(self, *args, **kwargs):
        p = self.params(*args, **kwargs)
        return self.get_with_params(p)
