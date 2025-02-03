from utils import secrets

def test_client():
    c = secrets.infisical_client()
    c.list_secrets()