from integrations.sources.lubw import lib
import httpx

def test_documentation():
    httpx.get(lib.lubw_documentation)
    httpx.raise_for_status()
