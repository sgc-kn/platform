# SGC Klimadatenplattform

## German Abstract (TODO)

## What is this about? (TODO)

## Open Source

This project is spronsored by the [Smart City grant program](https://www.smart-city-dialog.de/ueber-uns/modellprojekte-smart-cities) in Germany.
This grant program mandates that all software components—whether deployed as-is, modified, or written anew—are open source.

## Stack

Our data platform is based on a managed instance of [Hypertegrity's Urban Data Space Platform (UDSP)](https://www.hypertegrity.de/urban-data-space-platform/).
We use the following features and components:
- [Keycloak](https://www.keycloak.org/) to manage identities and access of internal and external participants. 
- Data is  compartmentalized in various *"data spaces"*, each with their own access rules.
- The data lives in [Timescale](https://github.com/timescale/timescaledb)/[Postgres](https://www.postgresql.org/) databases.
- [Node-RED](https://nodered.org/) for low-code data integrations and automation.
- [Grafana](https://grafana.com/) for internal dashboards, monitoring, and alerting.
- Some [FIWARE](https://www.fiware.org/) components ([Stellio](https://stellio.readthedocs.io), [Quantumleap](https://quantumleap.readthedocs.io)) to provide (partially) [NGSI-LD](https://ngsild.org/) compliant APIs.
- [PostgREST](https://docs.postgrest.org/) to expose RESTful APIs for the Postgres databases directly. (This is a custom addition to the UDSP stack.)
- [APISIX](https://apisix.apache.org/) to enforce access control on the public API endpoints.

We are also experimenting with potential modifications to this stack:
- Replace Node-RED (development + deployment) with Python notebooks (development) and an orchestrator like [Airflow](https://airflow.apache.org/) or [Dagster](https://dagster.io/) (deployment).
- Cloud-based development environments (currently [Github Codespaces](https://github.com/features/codespaces), later an open source alternative like [Coder](https://coder.com/cde) or [Eclipse Che](https://eclipse.dev/che/)).
- Complement the Postgres databases with S3-based data storage such as [Delta Lake](https://delta.io/).
- [Infisical](https://infisical.com/) for secret management.

## Data Sources

We integrate multiple data sources into our data platform:

- Car traffic counts from the Federal Highway and Transport Research Institute (bast) in [`./integrations/bast/`](./integrations/bast/).
- Extreme weather alarms, weather observations, and weather forecast data from the National Meteorological Service (DWD) in [`./integrations/dwd/`](./integrations/dwd/).
- Bicycle traffic counts from eco-counter monitors in [`./integrations/ecocounter/`](./integrations/ecocounter/).
- Usage metrics from our internal dashboard solution in [`./integrations/internal-reporting/`](./integrations/internal-reporting).
- Pedestrian traffic counts from lasepeco monitors in [`./integrations/lasepeco/`](./integrations/lasepeco/).
- Air quality data from Baden-Württemberg State Institute for the Environment (LUBW) in [`./integrations/lubw/`](./integrations/lubw/).
- Solar power production capacity and e-charging availability data from the national "Marktstammdatenregister" (MaStR) in [`./integrations/marktstammdatenregister/`](./integrations/marktstammdatenregister/).
- Bike-hire and free-floating scooter availability from Mobidata BW in [`./integrations/mobidata/`](./integrations/mobidata/).
- Water level data from Pegelonline in [`./integrations/pegelonline/`](./integrations/pegelonline/).
- Weather observation data from our own weather stations in [`./integrations/sgc-weather/`](./integrations/sgc-weather/).
- Parking facility utilization data in [`./integrations/skn-gis-parkdaten/`](./integrations/skn-gis-parkdaten/).

If applicable, data sources are filtered for the region of Constance. We generally record historic values to obtain timeseries data.

### Node-RED

Some of these integrations are implemented and deployed as Node-RED flows. We generally use one UDSP data space per data source and one productive Node-RED instance per data space. Integrations which are based on Node-RED have their Node-RED project tracked as [separate Git repositories](https://github.com/orgs/sgc-kn/repositories?q=node-red-project). These Node-RED projects are then linked into the respective integrations folder in this repository using [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) (e.g., [`./integrations/dwd/nodered`](./integrations/dwd/nodered`)). Additional documentation on how we manage the different Node-RED code repositories on multiple Node-RED instances is available in [`./documentation/nodered-projects.md`](./documentation/nodered-projects.md).

## Experimental Stack (WIP)

- Python notebooks in `./integrations/*/*.ipynb`.
- Reusable parts of the integrations as Python modules in `./integrations/*/*.py`.
- Configuration for scheduled execution on the orchestrator in `./integrations/*/jobs.py`.
- Globally reusable parts (e.g. for UDSP upload) in `./utils`.
- Plumbing for dagster orchestrator in `./utils/dagster`.
- A kubernetes deployment (ArgoCD, Dagster, the integration code, and Infisical secrets) in https://github.com/sgc-kn/k8s-sandbox.

## License and Copyright

Copyright © 2024-2025 [Stadt Konstanz](https://www.konstanz.de)

We release this code under the EUPL-1.2 License. See the LICENSE file
for details. Contributions to this project will be licensed under the same
terms.
