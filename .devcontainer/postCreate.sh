#!/usr/bin/env bash
set -e

# configure git lfs
git lfs pull # get large files
git lfs install # automate git lfs pull in the future
git config --global diff.lfs.textconv cat # diff large files like usual files
git submodule foreach --recursive git lfs pull # first git lfs pull for the submodules, automated later by git lfs install

# install uv (used for Python package management)
pipx install uv

# create Python virtual environment .venv with all Python dependencies (used as default Python interpreter)
uv sync