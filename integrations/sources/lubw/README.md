Datenquelle
- LUBW Luftqualitätsmessung Station Konstanz
- CO2, Ozon (02), Stickstoffdioxid (NO2), Schwebstoffe (PM2.5, PM10)
- https://mersyzentrale.lubw.de/www/Datenweitergabe/Konstanz/Schnittstellen-Dokumentation.pdf
- 100 Datenpunkte pro HTTP Request

Vorgehen
- Download, gebatched mit 100 Punkten pro Request (`lib.py`)
- Erstellung Pandas Dataframe (`lib.py`)
- Upload in DeltaLake (`lib.py`)
- Synchronisierung der letzten Werte (`sync-latest.ipynb`)
- Synchronisierung der historischen Daten (`backfill.ipynb`)