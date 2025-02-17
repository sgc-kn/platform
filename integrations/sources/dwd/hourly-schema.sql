DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_air_temperature_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_air_temperature_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_air_temperature_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_air_temperature_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_air_temperature_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_air_temperature_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_air_temperature_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_air_temperature_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_air_temperature CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_air_temperature (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_9" INTEGER,
  "TT_TU" REAL,
  "RF_TU" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness_missing_values CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness_missing_values (
"Stations_ID" INTEGER,
  "Stations_Name" TEXT,
  "Parameter" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Anzahl_Fehlwerte" INTEGER,
  "Beschreibung" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_cloudiness CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_cloudiness (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "V_N_I" TEXT,
  "V_N" INTEGER
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_dew_point_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_dew_point_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_dew_point_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_dew_point_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_dew_point_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_dew_point_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_dew_point_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_dew_point_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_dew_point CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_dew_point (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "TT" REAL,
  "TD" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_pressure_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_pressure_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_pressure_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_pressure_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_pressure_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_pressure_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_pressure_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_pressure_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_pressure CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_pressure (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "P" REAL,
  "P0" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_soil_temperature_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_soil_temperature_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_soil_temperature_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_soil_temperature_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_soil_temperature_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_soil_temperature_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_soil_temperature_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_soil_temperature_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_soil_temperature CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_soil_temperature (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_2" INTEGER,
  "V_TE002" REAL,
  "V_TE005" REAL,
  "V_TE010" REAL,
  "V_TE020" REAL,
  "V_TE050" REAL,
  "V_TE100" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_visibility_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_visibility_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_visibility_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_visibility_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_visibility_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_visibility_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_visibility_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_visibility_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_visibility CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_visibility (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "V_VV_I" TEXT,
  "V_VV" INTEGER
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_3" INTEGER,
  "F" REAL,
  "D" INTEGER
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation_missing_values CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation_missing_values (
"Stations_ID" INTEGER,
  "Stations_Name" TEXT,
  "Parameter" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Anzahl_Fehlwerte" INTEGER,
  "Beschreibung" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_precipitation CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_precipitation (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "R1" REAL,
  "RS_IND" INTEGER,
  "WRTR" INTEGER
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_sun_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_sun_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_sun_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_sun_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_sun_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_sun_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_sun_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_sun_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_sun CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_sun (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_7" INTEGER,
  "SD_SO" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_moisture_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_moisture_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_moisture_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_moisture_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_moisture_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_moisture_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_moisture_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_moisture_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_moisture CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_moisture (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_extreme_wind_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_extreme_wind_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_extreme_wind_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_extreme_wind_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_extreme_wind_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_extreme_wind_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_extreme_wind_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_extreme_wind_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_extreme_wind CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_extreme_wind (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "FX_911" REAL
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_synop_name CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_synop_name (
"Stations_ID" INTEGER,
  "Stationsname" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_synop_operator CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_synop_operator (
"Stations_ID" INTEGER,
  "Betreibername" TEXT,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_synop_parameter CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_synop_parameter (
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
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_synop_geo CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_synop_geo (
"Stations_id" INTEGER,
  "Stationshoehe" REAL,
  "Geogr.Breite" REAL,
  "Geogr.Laenge" REAL,
  "Von_Datum" TIMESTAMP,
  "Bis_Datum" TIMESTAMP,
  "Stationsname" TEXT
)
DROP TABLE IF EXISTS postgrest_dwd.climate_hourly_wind_synop CASCADE
CREATE TABLE postgrest_dwd.climate_hourly_wind_synop (
"STATIONS_ID" INTEGER,
  "MESS_DATUM" TIMESTAMP,
  "QN_8" INTEGER,
  "FF" REAL,
  "DD" INTEGER
)
