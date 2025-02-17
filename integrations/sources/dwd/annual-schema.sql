DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_parameter (
"Stations_ID" INTEGER,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT,
  "Parameter" TEXT,
  "Parameterbeschreibung" TEXT,
  "Einheit" TEXT,
  "Datenquelle (Strukturversion=SV)" TEXT,
  "Zusatz-Info" TEXT,
  "Besonderheiten" REAL,
  "Literaturhinweis" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_missing_values (
"Stations_ID" INTEGER,
  "Stations_Name" TEXT,
  "Parameter" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Anzahl_Fehlwerte" INTEGER,
  "Beschreibung" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM_BEGINN" TIMESTAMP,
  "MESS_DATUM_ENDE" TIMESTAMP,
  "QN_4" INTEGER,
  "JA_N" REAL,
  "JA_TT" REAL,
  "JA_TX" REAL,
  "JA_TN" REAL,
  "JA_FK" REAL,
  "JA_SD_S" REAL,
  "JA_MX_FX" REAL,
  "JA_MX_TX" REAL,
  "JA_MX_TN" REAL,
  "QN_6" INTEGER,
  "JA_RR" REAL,
  "JA_MX_RS" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_parameter (
"Stations_ID" INTEGER,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT,
  "Parameter" TEXT,
  "Parameterbeschreibung" TEXT,
  "Einheit" TEXT,
  "Datenquelle (Strukturversion=SV)" TEXT,
  "Zusatz-Info" TEXT,
  "Besonderheiten" REAL,
  "Literaturhinweis" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM_BEGINN" TIMESTAMP,
  "MESS_DATUM_ENDE" TIMESTAMP,
  "QN_4" INTEGER,
  "JA_TROPENNAECHTE" INTEGER,
  "JA_FROSTTAGE" INTEGER,
  "JA_SOMMERTAGE" INTEGER,
  "JA_HEISSE_TAGE" INTEGER,
  "JA_EISTAGE" INTEGER
)
