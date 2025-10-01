# SGC Klimadatenplattform

## German Abstract (TODO)

## Open Source

This project is pronsored by the [Smart City grant program](https://www.smart-city-dialog.de/ueber-uns/modellprojekte-smart-cities) in Germany.
This grant program mandates that all software components—whether deployed as-in, modified, or written anew—are open source.

## Stack

The heart of our data platform is a managed instance of [Hypertegrity's Urban Data Space Platform (UDSP)](https://www.hypertegrity.de/urban-data-space-platform/).
We use the following features and components:
- [Keycloak](https://www.keycloak.org/) to manage identities and access of internal and external participants. 
- Data is  compartmentalized in various *"data spaces"*, each with their own access rules.
- The data lives in [Timescale](https://github.com/timescale/timescaledb)/[Postgres](https://www.postgresql.org/) databases.
- [Node-RED (low-code programming environment)](https://nodered.org/) for data integrations and automation.
- [Grafana](https://grafana.com/) for internal dashboards, monitoring, and alerting.
- Some [FIWARE](https://www.fiware.org/) components ([Stellio](https://stellio.readthedocs.io), [Quantumleap](https://quantumleap.readthedocs.io)) to provide (partially) [NGSI-LD](https://ngsild.org/) compliant APIs.
- [PostgREST](https://docs.postgrest.org/) to expose RESTful APIs for the Postgres databases directly. (This is a custom addition to the UDSP stack.)
- [APISIX](https://apisix.apache.org/) to enforce access control on the public API endpoints.

We are also experimenting with potential modifications to this stack:
- Replace Node-RED (development + deployment) with Python notebooks (development) and an orchestrator like [Airflow](https://airflow.apache.org/) or [Dagster](https://dagster.io/) (deployment).
- Complement the Postgres databases with S3-based data storage such as [Delta Lake](https://delta.io/).
- [Infisical](https://infisical.com/) for secret management.

## Data Sources (TODO)

## Node-RED integrations (WIP)

- One instance per data space (`./integrations/*/nodered` submodules and `github.com/sgc-kn/nr-flows-*` repositories)
- Submodule and Node-RED setup in `./documentation/nodered-projects.md`)

## Experimental Stack (WIP)

- Python notebooks in `./integrations/*/*.ipynb`.
- Reusable parts of the integrations as Python modules in `./integrations/*/*.py`.
- Configuration for scheduled execution on the orchestrator in `./integrations/*/jobs.py`.
- Globally reusable parts (e.g. for UDSP upload) in `./utils`.
- Plumbing for dagster orchestrator in `./utils/dagster`.
- A kubernetes deployment (ArgoCD, Dagster, the integration code, and Infisical external secrets) in https://github.com/sgc-kn/k8s-sandbox.

## License (TODO)
