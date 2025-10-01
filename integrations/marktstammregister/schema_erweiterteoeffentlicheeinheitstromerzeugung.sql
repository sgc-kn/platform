
CREATE SCHEMA IF NOT EXISTS postgrest_mastr;
drop table if exists postgrest_mastr.erweiterteoeffentlicheeinheitstromerzeugung cascade;
create table postgrest_mastr.erweiterteoeffentlicheeinheitstromerzeugung (
id text ,
anlagenbetreiberid text,
anlagenbetreibermastrnummer text,
anlagenbetreibername text,
betriebsstatusid integer,
betriebsstatusname text,
datumletzteaktualisierung timestamptz,
einheitmeldedatum text,
einheitname text,
inbetriebnahmedatum date,
mastrnummer text,
personenartid text,
typ integer,
ort text,
plz text,
anzahlsolarmodule decimal,
bruttoleistung decimal,
energietraegername text,
flurstueck text,
isanonymisiert text,
ispilotwindanlage text,
lokationid text,
Nettonennleistung decimal
);
comment on table postgrest_mastr.erweiterteoeffentlicheeinheitstromerzeugung is 'erweiterte öffentliche einheit stromerzeugung für gemeindeschluessel 08335043';
    
