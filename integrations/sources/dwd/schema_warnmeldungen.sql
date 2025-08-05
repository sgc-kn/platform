
CREATE SCHEMA IF NOT EXISTS postgrest_dwd;
create table IF NOT EXISTS postgrest_dwd.warnmeldungen (
zeitstempel timestamptz,
region_id text ,
bundesland text,
regionname text,
event text,
level integer,
type integer,
startdatum timestamptz,
enddatum timestamptz,
headline text,
beschreibung text,
anweisung text
);
comment on table postgrest_dwd.warnmeldungen is 'DWD Warnmeldungen für Gemeindeschluessel Stadt Konstanz 808335043';
    
