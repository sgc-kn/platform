
drop table if exists traffic_ch cascade;
create table traffic_ch (
  zst integer not null,
  name text not null,
  richtung text not null,
  von timestamptz not null,
  bis timestamptz not null,
  count integer not null
);
select create_hypertable('traffic_ch', 'von');
comment on table traffic_ch is 'Schweizer Dauerzählstellen an den Konstanzer Grenzübergängen';
comment on column traffic_ch.zst is 'ID der Zählstelle';
comment on column traffic_ch.name is 'Name der Zählstelle';
comment on column traffic_ch.richtung is 'Fahrtrichtung';
comment on column traffic_ch.von is 'Start des Beobachtungszeitraums';
comment on column traffic_ch.bis is 'Ende des Beobachtungszeitraums';
comment on column traffic_ch.count is 'Anzahl Fahrzeuge in Beobachtungszeitraum und Richtung';

