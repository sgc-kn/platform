import os
import subprocess
import yaml


def load():
    ctp = os.path.join(os.path.dirname(__file__), "../secrets/secrets.yaml")
    idp = os.path.join(os.path.dirname(__file__), "../secrets/identity")
    spr = subprocess.run(
        ["sops", "--decrypt", ctp],
        env=dict(PATH=os.getenv("PATH"), SOPS_AGE_KEY_FILE=idp),
        capture_output=True,
        text=True,
        check=True,
    )
    return yaml.safe_load(spr.stdout)


def get(*args):
    if not hasattr(get, "_secrets"):
        get._secrets = load()

    x = get._secrets
    for k in args:
        x = x[k]
    return x
