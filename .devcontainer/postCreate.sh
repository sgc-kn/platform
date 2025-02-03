#!/usr/bin/env bash
set -e

# configure git lfs
command -v git-lfs # check git-lfs installed?
git config --global diff.lfs.textconv cat

# install uv (used for Python package management)
pipx install uv

# create Python virtual environment .venv with all Python dependencies (used as default Python interpreter)
uv sync