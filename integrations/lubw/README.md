**Datenquelle**
- LUBW Luftqualitätsmessung Station Konstanz
- CO2, Ozon (O2), Stickstoffdioxid (NO2), Schwebstoffe (PM2.5, PM10)
- https://mersyzentrale.lubw.de/www/Datenweitergabe/Konstanz/Schnittstellen-Dokumentation.pdf
- 100 Datenpunkte pro HTTP Request


**Data Lake**
- Download, gebatched mit 100 Punkten pro Request (`lib.py`)
- Erstellung Pandas Dataframe (`lib.py`)
- Upload in DeltaLake (`lib.py`)
- Synchronisierung der historischen Daten (`backfill.ipynb`, manuell)
- Synchronisierung der letzten Werte (`sync-latest.ipynb`, täglich)

**UDSP Integration**
- Inkrementeller Sync der LUBW Quelle in Postgres Datenbank
- NodeRed Flows in Submodule `./nodered`


**Öffentlicher Share**
- Upload aus Data Lake in öffentlichen Bucket (`push-hourly-to-public-s3.ipynb`):
  - https://sgc-public-prod-de-wu5va7ls.s3-eu-central-1.ionoscloud.com/share/lubw/hourly/lubw-hourly-2008.csv
  - https://sgc-public-prod-de-wu5va7ls.s3-eu-central-1.ionoscloud.com/share/lubw/hourly/lubw-hourly-2009.csv
  - ...
  - https://sgc-public-prod-de-wu5va7ls.s3-eu-central-1.ionoscloud.com/share/lubw/hourly/lubw-hourly-2025.csv
- Das laufende Jahr wird täglich aktualisiert (wie Data Lake, täglich)
