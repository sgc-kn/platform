-- 
-- execute_many
-- 
CREATE SCHEMA IF NOT EXISTS postgrest_dwd
-- 
-- execute_many
-- 
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
-- 
-- execute_many
-- 
DROP MATERIALIZED VIEW IF EXISTS postgrest_dwd.annual;
CREATE MATERIALIZED VIEW postgrest_dwd.annual AS SELECT
      COALESCE(tab0."MESS_DATUM_BEGINN", tab1."MESS_DATUM_BEGINN") AS datum,
      tab0."JA_FK" AS ja_fk,
      tab0."JA_MX_FX" AS ja_mx_fx,
      tab0."JA_MX_RS" AS ja_mx_rs,
      tab0."JA_MX_TN" AS ja_mx_tn,
      tab0."JA_MX_TX" AS ja_mx_tx,
      tab0."JA_N" AS ja_n,
      tab0."JA_RR" AS ja_rr,
      tab0."JA_SD_S" AS ja_sd_s,
      tab0."JA_TN" AS ja_tn,
      tab0."JA_TT" AS ja_tt,
      tab0."JA_TX" AS ja_tx,
      tab1."JA_EISTAGE" AS ja_eistage,
      tab1."JA_FROSTTAGE" AS ja_frosttage,
      tab1."JA_HEISSE_TAGE" AS ja_heisse_tage,
      tab1."JA_SOMMERTAGE" AS ja_sommertage,
      tab1."JA_TROPENNAECHTE" AS ja_tropennaechte
    FROM postgrest_dwd.raw_climate_annual_kl_product tab0
    FULL OUTER JOIN postgrest_dwd.raw_climate_annual_climate_indices_kl_product tab1 ON tab0."MESS_DATUM_BEGINN" = tab1."MESS_DATUM_BEGINN";
CREATE INDEX ON postgrest_dwd.annual (datum)
-- 
-- execute_many
-- 
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_9" INTEGER,
  "TT_TU" REAL,
  "RF_TU" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_missing_values (
"Stations_ID" INTEGER,
  "Stations_Name" TEXT,
  "Parameter" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Anzahl_Fehlwerte" INTEGER,
  "Beschreibung" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "V_N_I" TEXT,
  "V_N" INTEGER
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "TT" REAL,
  "TD" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_parameter (
"Stations_ID" INTEGER,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT,
  "Parameter" TEXT,
  "Parameterbeschreibung" TEXT,
  "Einheit" REAL,
  "Datenquelle (Strukturversion=SV)" TEXT,
  "Zusatz-Info" TEXT,
  "Besonderheiten" REAL,
  "Literaturhinweis" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "P" REAL,
  "P0" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_2" INTEGER,
  "V_TE002" REAL,
  "V_TE005" REAL,
  "V_TE010" REAL,
  "V_TE020" REAL,
  "V_TE050" REAL,
  "V_TE100" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "V_VV_I" TEXT,
  "V_VV" INTEGER
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_3" INTEGER,
  "F" REAL,
  "D" INTEGER
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_missing_values (
"Stations_ID" INTEGER,
  "Stations_Name" TEXT,
  "Parameter" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Anzahl_Fehlwerte" INTEGER,
  "Beschreibung" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "R1" REAL,
  "RS_IND" INTEGER,
  "WRTR" INTEGER
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_parameter (
"Stations_ID" INTEGER,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT,
  "Parameter" TEXT,
  "Parameterbeschreibung" TEXT,
  "Einheit" REAL,
  "Datenquelle (Strukturversion=SV)" TEXT,
  "Zusatz-Info" TEXT,
  "Besonderheiten" REAL,
  "Literaturhinweis" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_7" INTEGER,
  "SD_SO" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "ABSF_STD" REAL,
  "VP_STD" REAL,
  "TF_STD" REAL,
  "P_STD" REAL,
  "TT_STD" REAL,
  "RF_STD" REAL,
  "TD_STD" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "FX_911" REAL
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_parameter (
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
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_product (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "FF" REAL,
  "DD" INTEGER
)
-- 
-- execute_many
-- 
DROP MATERIALIZED VIEW IF EXISTS postgrest_dwd.hourly;
CREATE MATERIALIZED VIEW postgrest_dwd.hourly AS SELECT
      COALESCE(tab0."MESS_DATUM", tab1."MESS_DATUM", tab2."MESS_DATUM", tab3."MESS_DATUM", tab4."MESS_DATUM", tab5."MESS_DATUM", tab6."MESS_DATUM", tab7."MESS_DATUM", tab8."MESS_DATUM", tab9."MESS_DATUM", tab10."MESS_DATUM", tab11."MESS_DATUM") AS datum,
      tab0."RF_TU" AS rf_tu,
      tab0."TT_TU" AS tt_tu,
      tab1."V_N" AS v_n,
      tab2."TD" AS td,
      tab2."TT" AS tt,
      tab3."P" AS p,
      tab3."P0" AS p0,
      tab4."V_TE002" AS v_te002,
      tab4."V_TE005" AS v_te005,
      tab4."V_TE010" AS v_te010,
      tab4."V_TE020" AS v_te020,
      tab4."V_TE050" AS v_te050,
      tab4."V_TE100" AS v_te100,
      tab5."V_VV" AS v_vv,
      tab6."D" AS d,
      tab6."F" AS f,
      tab7."R1" AS r1,
      tab7."RS_IND" AS rs_ind,
      tab7."WRTR" AS wrtr,
      tab8."SD_SO" AS sd_so,
      tab9."ABSF_STD" AS absf_std,
      tab9."P_STD" AS p_std,
      tab9."RF_STD" AS rf_std,
      tab9."TD_STD" AS td_std,
      tab9."TF_STD" AS tf_std,
      tab9."TT_STD" AS tt_std,
      tab9."VP_STD" AS vp_std,
      tab10."FX_911" AS fx_911,
      tab11."DD" AS dd,
      tab11."FF" AS ff
    FROM postgrest_dwd.raw_climate_hourly_air_temperature_product tab0
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_cloudiness_product tab1 ON tab0."MESS_DATUM" = tab1."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_dew_point_product tab2 ON tab0."MESS_DATUM" = tab2."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_pressure_product tab3 ON tab0."MESS_DATUM" = tab3."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_soil_temperature_product tab4 ON tab0."MESS_DATUM" = tab4."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_visibility_product tab5 ON tab0."MESS_DATUM" = tab5."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_wind_product tab6 ON tab0."MESS_DATUM" = tab6."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_precipitation_product tab7 ON tab0."MESS_DATUM" = tab7."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_sun_product tab8 ON tab0."MESS_DATUM" = tab8."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_moisture_product tab9 ON tab0."MESS_DATUM" = tab9."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_extreme_wind_product tab10 ON tab0."MESS_DATUM" = tab10."MESS_DATUM"
    FULL OUTER JOIN postgrest_dwd.raw_climate_hourly_wind_synop_product tab11 ON tab0."MESS_DATUM" = tab11."MESS_DATUM";
CREATE INDEX ON postgrest_dwd.hourly (datum)
