
drop table if exists schlagfallen_ebk cascade;
create table schlagfallen_ebk (
  berichtsmonat timestamptz not null,
  seriennummer text not null,
  art text not null,
  latitude double precision not null,
  longitude double precision not null,
  adresse text not null,
  plz text not null,
  ort text not null,
  name text not null,
  letzter_schuss timestamptz not null,
  schuesse integer not null,
  schuesse_akkumuliert integer not null,
  hinweis text ,
  verlegt text 
);
select create_hypertable('schlagfallen_ebk', 'berichtsmonat');
comment on table schlagfallen_ebk is 'Schlagfallen Schüsse je Monat und Aufstellungsort';

