#!/usr/bin/env bash
set -e

# configure git lfs
git lfs pull # get large files
git lfs install # automate git lfs pull in the future
git config --global diff.lfs.textconv cat # diff large files like usual files

# configure submodules
git submodule update --init --recursive
git submodule foreach --recursive git lfs pull # first git lfs pull for the submodules, automated by git lfs install from now on

# install uv (used for Python package management) and just (for small maintenance scripts)
pipx install rust-just uv

# create Python virtual environment .venv with all Python dependencies (used as default Python interpreter)
uv sync