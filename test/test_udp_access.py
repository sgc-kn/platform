from integrations.sinks.udsp.auth import udp_auth
import httpx
import os


def test_auth():
    udp_auth()


def test_postgrest_mgmt():
    url = f"https://api.{os.environ['UDP_DOMAIN']}/postgrest-mgmt/"
    r = httpx.get(url, auth=udp_auth())
    r.raise_for_status()
