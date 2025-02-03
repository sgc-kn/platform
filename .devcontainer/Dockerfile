FROM mcr.microsoft.com/devcontainers/python:3

RUN apt-get update \
    && apt-get install -y git-lfs \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY postCreate.sh /