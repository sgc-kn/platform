import httpx
import time
import os
from typing import Optional


class BearerTokenAuthenticator(httpx.Auth):
    def __init__(
        self,
        auth_url: str,
        **kwargs,
    ):
        self.auth_url = auth_url
        self.kwargs = kwargs
        self.token: Optional[str] = None
        # Expiration time in UNIX timestamp
        self.token_expiry: Optional[int] = None

    def _fetch_token(self) -> str:
        """
        Fetches a new bearer token from the authentication server.
        """
        response = httpx.post(self.auth_url, **self.kwargs)
        response.raise_for_status()
        token_data = response.json()
        token = token_data["access_token"]
        expires_in = token_data["expires_in"]  # Typically seconds until expiry
        self.token_expiry = int(time.time()) + \
            expires_in - 10  # Buffer of 10 seconds
        return token

    def _is_token_expired(self) -> bool:
        """
        Checks if the current token is expired or about to expire.
        """
        if not self.token_expiry:
            return True
        return time.time() >= self.token_expiry

    def _get_token(self) -> str:
        """
        Retrieves the token, fetching a new one if necessary.
        """
        if not self.token or self._is_token_expired():
            self.token = self._fetch_token()
        return self.token

    def auth_flow(self, request: httpx.Request):
        """
        Injects the Authorization header with a valid token.
        """
        token = self._get_token()
        request.headers["Authorization"] = f"Bearer {token}"
        return request


class UDSPApiAuthenticator(httpx.Auth):
    def __init__(
        self,
        *,
        realm_url: str,
        client_id: str,
        client_secret: str,
        username: str,
        password: str,
        scopes: list,
    ):
        self.authenticator = BearerTokenAuthenticator(
            f"{realm_url}/protocol/openid-connect/token",
            data=dict(
                client_id=client_id,
                client_secret=client_secret,
                grant_type="password",
                username=username,
                password=password,
                scope=" ".join(f"api:{x}" for x in scopes),
            ),
        )

    def auth_flow(self, request: httpx.Request):
        yield self.authenticator.auth_flow(request)


def udp_auth():
    return UDSPApiAuthenticator(
        realm_url=f"https://idm.{os.environ['UDP_DOMAIN']
                                 }/auth/realms/{os.environ['UDP_IDM_REALM']}",
        client_id=os.environ['UDP_IDM_CLIENT_ID'],
        client_secret=os.environ['UDP_IDM_CLIENT_SECRET'],
        username=os.environ['UDP_USERNAME'],
        password=os.environ['UDP_PASSWORD'],
        scopes=["read", "write", "delete"],
    )
