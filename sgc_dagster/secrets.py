import os
import yaml

def get(*args):
    path = os.getenv("XDG_RUNTIME_DIR") + "/sgc-dagster/secrets.yaml"
    with open(path, 'r') as f:
        secrets = yaml.safe_load(f)
    x = secrets
    for k in args:
        x = x[k]
    return x
