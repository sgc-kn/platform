-- 
-- execute_many
-- 
CREATE SCHEMA IF NOT EXISTS postgrest_dwd
-- 
-- execute_many
-- 
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_missing_values (
  "Stations_ID"    smallint,
  "Stations_Name"    text,
  "Parameter"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Anzahl_Fehlwerte"    bigint,
  "Beschreibung"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_kl_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_kl_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM_BEGINN"    timestamp,
  "MESS_DATUM_ENDE"    timestamp,
  "QN_4"    bigint,
  "JA_N"    double precision,
  "JA_TT"    double precision,
  "JA_TX"    double precision,
  "JA_TN"    double precision,
  "JA_FK"    double precision,
  "JA_SD_S"    double precision,
  "JA_MX_FX"    double precision,
  "JA_MX_TX"    double precision,
  "JA_MX_TN"    double precision,
  "QN_6"    bigint,
  "JA_RR"    double precision,
  "JA_MX_RS"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_annual_climate_indices_kl_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_annual_climate_indices_kl_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM_BEGINN"    timestamp,
  "MESS_DATUM_ENDE"    timestamp,
  "QN_4"    bigint,
  "JA_TROPENNAECHTE"    bigint,
  "JA_FROSTTAGE"    bigint,
  "JA_SOMMERTAGE"    bigint,
  "JA_HEISSE_TAGE"    bigint,
  "JA_EISTAGE"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.annual CASCADE;
CREATE TABLE postgrest_dwd.annual (
  "Jahr"    timestamptz,
  "Jahresmittel der Windstaerke (Bft)"    double precision,
  "Absolutes Maximum der Windmaxspitze (m/s)"    double precision,
  "Maximale Niederschlagshoehe des Jahres (mm)"    double precision,
  "Absolutes Minimum der Lufttemperatur in 2m Hoehe (Jahr) (°C)"    double precision,
  "Absolutes Maximum der Lufttemperatur in 2m Hoehe (Jahr) (°C)"    double precision,
  "Jahresmittel des Bedeckungsgrades (Achtel)"    double precision,
  "Jahressumme der Niederschlagshoehe (mm)"    double precision,
  "Jahressumme der Sonnenscheindauer (Stunde)"    double precision,
  "Jahresmittel des Lufttemperatur Minimums (°C)"    double precision,
  "Jahresmittel der Lufttemperatur (°C)"    double precision,
  "Jahresmittel der Lufttemperatur Maximum (°C)"    double precision,
  "Anzahl der Eistage im Jahr"    double precision,
  "Anzahl der Frostage im Jahr"    double precision,
  "Anzahl der Heisse Tage/Tropentage im Jahr"    double precision,
  "Anzahl der Sommertage im Jahr"    double precision,
  "Anzahl der Tropennaechte (00 - 23 Uhr) im Jahr"    double precision)
-- 
-- execute_many
-- 
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_air_temperature_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_air_temperature_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_9"    bigint,
  "TT_TU"    double precision,
  "RF_TU"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_missing_values (
  "Stations_ID"    smallint,
  "Stations_Name"    text,
  "Parameter"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Anzahl_Fehlwerte"    bigint,
  "Beschreibung"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_cloudiness_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_cloudiness_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "V_N_I"    text,
  "V_N"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_dew_point_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_dew_point_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "TT"    double precision,
  "TD"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    double precision,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_pressure_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_pressure_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "P"    double precision,
  "P0"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_soil_temperature_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_soil_temperature_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_2"    bigint,
  "V_TE002"    double precision,
  "V_TE005"    double precision,
  "V_TE010"    double precision,
  "V_TE020"    double precision,
  "V_TE050"    double precision,
  "V_TE100"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_visibility_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_visibility_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "V_VV_I"    text,
  "V_VV"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_3"    bigint,
  "F"    double precision,
  "D"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_missing_values CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_missing_values (
  "Stations_ID"    smallint,
  "Stations_Name"    text,
  "Parameter"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Anzahl_Fehlwerte"    bigint,
  "Beschreibung"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_precipitation_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_precipitation_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "R1"    double precision,
  "RS_IND"    bigint,
  "WRTR"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    double precision,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_sun_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_sun_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_7"    bigint,
  "SD_SO"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_moisture_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_moisture_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "ABSF_STD"    double precision,
  "VP_STD"    double precision,
  "TF_STD"    double precision,
  "P_STD"    double precision,
  "TT_STD"    double precision,
  "RF_STD"    double precision,
  "TD_STD"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_extreme_wind_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_extreme_wind_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "FX_911"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_name CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_name (
  "Stations_ID"    smallint,
  "Stationsname"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_operator CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_operator (
  "Stations_ID"    smallint,
  "Betreibername"    text,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_parameter CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_parameter (
  "Stations_ID"    smallint,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text,
  "Parameter"    text,
  "Parameterbeschreibung"    text,
  "Einheit"    text,
  "Datenquelle (Strukturversion=SV)"    text,
  "Zusatz-Info"    text,
  "Besonderheiten"    double precision,
  "Literaturhinweis"    double precision);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_geo CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_geo (
  "Stations_id"    smallint,
  "Stationshoehe"    double precision,
  "Geogr.Breite"    double precision,
  "Geogr.Laenge"    double precision,
  "Von_Datum"    timestamp,
  "Bis_Datum"    timestamp,
  "Stationsname"    text);
DROP TABLE IF EXISTS postgrest_dwd.raw_climate_hourly_wind_synop_product CASCADE;
CREATE TABLE postgrest_dwd.raw_climate_hourly_wind_synop_product (
  "STATIONS_ID"    smallint,
  "MESS_DATUM"    timestamp,
  "QN_8"    bigint,
  "FF"    double precision,
  "DD"    bigint);
DROP TABLE IF EXISTS postgrest_dwd.hourly CASCADE;
CREATE TABLE postgrest_dwd.hourly (
  "Datum"    timestamptz,
  "relative Feuchte (%)"    double precision,
  "Lufttemperatur (°C)"    double precision,
  "Bedeckungsgrad aller Wolken (Achtel)"    double precision,
  "Taupunktstemperatur (°C)"    double precision,
  "Temperatur der Luft in 2m Hoehe (°C)"    double precision,
  "auf NN reduzierter Luftdruck"    double precision,
  "Luftdruck in Stationshoehe"    double precision,
  "Temperatur im Erdboden in 2 cm Tiefe (°C)"    double precision,
  "Temperatur im Erdboden in 5 cm Tiefe (°C)"    double precision,
  "Temperatur im Erdboden in 10 cm Tiefe (°C)"    double precision,
  "Temperatur im Erdboden in 20 cm Tiefe (°C)"    double precision,
  "Temperatur im Erdboden in 50 cm Tiefe (°C)"    double precision,
  "Temperatur im Erdboden in 1 m Tiefe (°C)"    double precision,
  "Sichtweite (m)"    double precision,
  "Windrichtung Messnetz 3 (Grad)"    double precision,
  "Windgeschwindigkeit Messnetz 3 (m/sec)"    double precision,
  "stdl. Niederschlagshoehe (mm)"    double precision,
  "Indikator Niederschlag ja/nein (numerischer Code)"    double precision,
  "stdl. Niederschlagsform (numerischer Code)"    double precision,
  "stdl. Sonnenscheindauer"    double precision,
  "berechnete Stundenwerte der absoluten Feuchte (g/m³)"    double precision,
  "Stundenwerte Luftdruck (hpa)"    double precision,
  "Stundenwerte der Relativen Feuchte (%)"    double precision,
  "Taupunkttemperatur in 2m Hoehe (°C)"    double precision,
  "berechnete Stundenwerte der Feuchttemperatur (°C)"    double precision,
  "Lufttemperatur in 2m Hoehe (°C)"    double precision,
  "berechnete Stundenwerte des Dampfdruckes (hpa)"    double precision,
  "hoechste Windspitze der letzten Stunde (m/sec)"    double precision,
  "Windrichtung uml.,windstill DD=00 (Grad)"    double precision,
  "10-Min-Mittel der Windgeschwindigkeit (m/sec)"    double precision);
SELECT create_hypertable('postgrest_dwd.hourly', 'Datum')
