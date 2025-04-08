NOTE: This description is out of date. I'm working on uploading the data
to delta lake instead of QuantumLeap.

## Context

I've used this to sync the historic lubw data. The data is now updated
via nodered nr-lubw. The development flow here was:

1. Try implementing incremental and historic sync (from lubw to
   quantumleap) Dagster job.
2. Learn that a single job is not suited to run historic sync. Error:
   too many open files; likely due to the excessive number of batches.
3. Implement historic sync from lubw to montly local csv as Dagster
   asset.
4. Upload the local csv files to quantumleap test environment in Python
   notebook.
5. Derive smartdatamodel using SQL.
6. Manually mirror the historic data to the existing prod tables.
7. Continue using the existing NodeRed integration to keep the prod
   tables up to date.

## Backlog

This leaves open a couple of tasks for the future:

- [ ] The historic dagster asset builds dataframes and csv. The
  incremental sync job maps lubw json to quantumleap json. I think the
  incremental job should use the logic of the dagster asset, and do a
  detour via dataframes as well.
- [ ] Avoid code duplication between the sync job, monthly asset, and
  quantumleap upload.
- [ ] The notebook-backed upload of historic data was flaky, with
  multiple manual restarts. This should be automated in Dagster with
  automatic retries, similar to the monthly historic asset.
- [ ] There is no schedule yet to materialize the monthly historic
  assets.
- [ ] Dagster should take care of the smart data model representation.

## Source Documentation

https://mersyzentrale.de/www/Datenweitergabe/Konstanz/Schnittstellen-Dokumentation.pdf
