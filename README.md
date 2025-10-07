# SGC Klimadatenplattform

## German Abstract

Die [SGC Klimadatenplattform](https://smart-green-city-konstanz.de/klimadatenplattform) der Stadt Konstanz bündelt Klima‑, Umwelt‑ und mobilitätsbezogene Zeitreihen in einer einheitlichen, rechtskonformen Infrastruktur. Sensorströme, amtliche Datensätze und betriebliche Kennzahlen werden zusammengeführt, strukturiert und über APIs sowie Dashboards bereitgestellt, um interne Abläufe, evidenzbasierte Planungen und Transparenz gegenüber der Öffentlichkeit zu unterstützen. Typische Anwendungsfälle umfassen etwa die Einsatzplanung des Winterdienstes, strategische Mobilitätsanalysen, Klimaanpassungsmaßnahmen sowie die Veröffentlichung auf Portalen wie [stadtdaten.konstanz.digital](https://stadtdaten.konstanz.digital/) und [offenedaten-konstanz.de](https://offenedaten-konstanz.de/).

Dieses Repository enthält die technischen Integrationen für die Datenplattform, inklusive wiederverwendbarer Module und Automatisierungen. Beispiele sind Anbindungen für Wetterstationen (DWD und eigene Stationen), Verkehrs- und Fahrradzählungen, Luftqualitätsmessungen, Pegelstände, Solar‑ und Ladeinfrastruktur sowie interne Betriebskennzahlen. Die Integrationen erfassen, bereinigen und speichern die Daten als Zeitreihen und stellen sie zur weiteren Nutzung in der Plattform zur Verfügung. Weitere Hintergrundinformationen zum Projekt finden Sie auf der Projektseite: Smart Green City Klimadatenplattform (https://smart-green-city-konstanz.de/klimadatenplattform).

## What is this about?

The [SGC Klimadatenplattform](https://smart-green-city-konstanz.de/klimadatenplattform) is the City of Konstanz’s data platform focused on climate, environment, and mobility-related time series. It consolidates sensor streams, official datasets, and operational metrics into a unified, policy-compliant infrastructure to support internal workflows, evidence-based planning, and public transparency.

Practically, the platform ingests and structures diverse sources (e.g., weather stations, traffic counters, air quality monitors, hydrology levels, renewable assets, and operational dashboards), persists them in time series databases, and exposes them via APIs and dashboards. This enables use cases such as winter service planning, strategic mobility analysis, climate adaptation measures, and publication on public portals (e.g., [stadtdaten.konstanz.digital](https://stadtdaten.konstanz.digital/) and [offenedaten-konstanz.de](https://offenedaten-konstanz.de/)), while enforcing appropriate access controls.

## Open Source

This project is sponsored by the [Smart City grant program](https://www.smart-city-dialog.de/ueber-uns/modellprojekte-smart-cities) in Germany.
This grant program mandates that all software components—whether deployed as-is, modified, or written anew—are open source.

## Stack

Our data platform is based on a managed instance of [Hypertegrity's Urban Data Space Platform (UDSP)](https://www.hypertegrity.de/urban-data-space-platform/).
We use the following features and components:
- [Keycloak](https://www.keycloak.org/) to manage identities and access of internal and external participants. 
- Data is compartmentalized in various *"data spaces"*, each with their own access rules.
- The data lives in [Timescale](https://github.com/timescale/timescaledb)/[Postgres](https://www.postgresql.org/) databases.
- [Node-RED](https://nodered.org/) for low-code data integrations and automation.
- [Grafana](https://grafana.com/) for internal dashboards, monitoring, and alerting.
- Some [FIWARE](https://www.fiware.org/) components ([Stellio](https://stellio.readthedocs.io), [Quantumleap](https://quantumleap.readthedocs.io)) to provide (partially) [NGSI-LD](https://ngsild.org/) compliant APIs.
- [PostgREST](https://docs.postgrest.org/) to expose RESTful APIs for the Postgres databases directly. (This is a custom addition to the UDSP stack.)
- [APISIX](https://apisix.apache.org/) to enforce access control on the public API endpoints.

We are also experimenting with potential modifications to this stack:
- Replace Node-RED (development + deployment) with Python notebooks (development) and an orchestrator like [Airflow](https://airflow.apache.org/) or [Dagster](https://dagster.io/) (deployment).
- Cloud-based development environments (currently [GitHub Codespaces](https://github.com/features/codespaces), later an open source alternative like [Coder](https://coder.com/) or [Eclipse Che](https://eclipse.dev/che/)).
- Complement the Postgres databases with S3-based data storage such as [Delta Lake](https://delta.io/).
- [Infisical](https://infisical.com/) for secret management.

## Data Sources

We integrate multiple data sources into our data platform:

- Car traffic counts from the Federal Highway and Transport Research Institute (BASt) in [`./integrations/bast/`](./integrations/bast/).
- Extreme weather alarms, weather observations, and weather forecast data from the National Meteorological Service (DWD) in [`./integrations/dwd/`](./integrations/dwd/).
- Bicycle traffic counts from Eco-Counter monitors in [`./integrations/ecocounter/`](./integrations/ecocounter/).
- Usage metrics from our internal dashboard solution in [`./integrations/internal-reporting/`](./integrations/internal-reporting).
- Pedestrian traffic counts from LASE PeCo monitors in [`./integrations/lasepeco/`](./integrations/lasepeco/).
- Air quality data from the Baden-Württemberg State Institute for the Environment (LUBW) in [`./integrations/lubw/`](./integrations/lubw/).
- Solar power production capacity and e-charging availability data from the national "Marktstammdatenregister" (MaStR) in [`./integrations/marktstammdatenregister/`](./integrations/marktstammdatenregister/).
- Bike-hire and free-floating scooter availability from MobiData BW in [`./integrations/mobidata/`](./integrations/mobidata/).
- Water level data from Pegelonline in [`./integrations/pegelonline/`](./integrations/pegelonline/).
- Weather observation data from our own weather stations in [`./integrations/sgc-weather/`](./integrations/sgc-weather/).
- Parking facility utilization data in [`./integrations/skn-gis-parkdaten/`](./integrations/skn-gis-parkdaten/).

If applicable, data sources are filtered for our region. We generally record historic values to obtain time series data.

### Node-RED

Some of these integrations are implemented and deployed as Node-RED flows. We generally use one UDSP data space per data source and one productive Node-RED instance per data space. Integrations which are based on Node-RED have their Node-RED project tracked as [separate Git repositories](https://github.com/orgs/sgc-kn/repositories?q=node-red-project). These Node-RED projects are then linked into the respective integrations folder in this repository using [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) (e.g., [`./integrations/dwd/nodered`](./integrations/dwd/nodered)). Additional documentation on how we manage the different Node-RED code repositories on multiple Node-RED instances is available in [`./documentation/nodered-projects.md`](./documentation/nodered-projects.md).

### Experimental Stack

Some other integrations are implemented as IPython notebooks (`./integrations/*/*.ipynb`). Reusable parts of the integration are maintained as separate modules, either in the integrations directory (`./integrations/*/*.py`) if they are related to a single data source, or in the [`./utils/`](./utils/) directory if they are applicable to multiple data sources (e.g., code for UDSP uploads in [`./utils/udsp`](./utils/udsp/)).

Some of the data sources are updated irregularly or at very long intervals. E.g., [BASt traffic count data](./integrations/bast/) updates once a year. For such integrations, we avoid the technical overhead of automation and run the respective notebooks manually and on demand.

We're experimenting with Dagster and Airflow to schedule the automatic execution of IPython/notebook-based integrations. The intended execution schedules are defined in the `jobs.py` file in the respective integration directory, e.g., [`./integrations/sgc-weather/jobs.py`](./integrations/sgc-weather/jobs.py) to mirror and persist all LoRaWAN messages from our TTI instance to S3 object storage. The Dagster glue code in [`./utils/dagster/`](./utils/dagster/) turns all these job definitions into a Dagster code location which we publish as Docker image on the [GitHub Container Registry (ghcr.io)](https://github.com/sgc-kn/platform/pkgs/container/platform).
A separate repository, [sgc-kn/k8s-sandbox](https://github.com/sgc-kn/k8s-sandbox), documents our actual deployment of Dagster and the Dagster code location on Kubernetes using ArgoCD.

Note: the integrations depend on various secrets like S3 bucket IDs and keys, UDSP access credentials, and data source API keys. We manage these secrets in [Infisical](https://infisical.com/) and sync them to the Kubernetes deployment using the [external secrets operator](https://external-secrets.io). Without those secrets, the integrations will inevitably fail.

### Python Development Environment

We found it very challenging to set up Python development environments on our corporate IT infrastructure (outbound firewall, no admin rights).
To avoid punching big holes into warranted defenses, we resorted to running all development‑related tasks outside the corporate network, either in the cloud or on unmanaged Linux devices with unrestricted root access. This repository supports [devenv](https://devenv.sh/), [devcontainers](https://containers.dev/), and [GitHub Codespaces](https://github.com/features/codespaces) to get you started quickly and reproducibly.

Note: the first step in any new development environment is to load the secrets from Infisical. Run `just dotenv` for that.

## License and Copyright

Copyright © 2024–2025 [Stadt Konstanz](https://www.konstanz.de)

We release this code under the EUPL-1.2 license. See the LICENSE file
for details. Contributions to this project will be licensed under the same
terms.
