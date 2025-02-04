FROM mcr.microsoft.com/devcontainers/python:3

# add infisical repo
RUN curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' | sudo -E bash

RUN apt-get update \
    && apt-get install -y git-lfs infisical \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY postCreate.sh /