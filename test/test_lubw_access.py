from integrations.lubw import lib
import httpx

def test_documentation():
    r = httpx.get(lib.lubw_documentation)
    r.raise_for_status()
