#!/bin/bash
set -euo pipefail

SOPS_AGE_RECIPIENTS=$(cat secrets/recipients/* | paste -sd,)
export SOPS_AGE_RECIPIENTS

SOPS_AGE_KEY_FILE=secrets/identity
export SOPS_AGE_KEY_FILE

exec sops --age "$SOPS_AGE_RECIPIENTS" $@
