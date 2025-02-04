import os


def test_udp_secrets():
    os.environ['UDP_DOMAIN']
    os.environ['UDP_IDM_CLIENT_ID']
    os.environ['UDP_IDM_CLIENT_SECRET']
    os.environ['UDP_IDM_REALM']
    os.environ['UDP_PASSWORD']
    os.environ['UDP_USERNAME']
