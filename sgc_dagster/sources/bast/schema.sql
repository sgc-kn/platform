drop table if exists bast;
create table bast (
  tknr double precision,
  zst double precision,
  land double precision,
  strklas text,
  strnum text,
  datum timestamptz,
  wotag double precision,
  fahrtzw text,
  stunde double precision,
  kfz_r1 double precision,
  kfz_r2 double precision,
  lkw_r1 double precision,
  lkw_r2 double precision,
  plz_r1 double precision,
  pkw_r1 double precision,
  lfw_r1 double precision,
  mot_r1 double precision,
  pma_r1 double precision,
  bus_r1 double precision,
  loa_r1 double precision,
  lzg_r1 double precision,
  sat_r1 double precision,
  son_r1 double precision,
  plz_r2 double precision,
  pkw_r2 double precision,
  lfw_r2 double precision,
  mot_r2 double precision,
  pma_r2 double precision,
  bus_r2 double precision,
  loa_r2 double precision,
  lzg_r2 double precision,
  sat_r2 double precision,
  son_r2 double precision,
  k_kfz_r1 double precision,
  k_kfz_r2 double precision,
  k_lkw_r1 double precision,
  k_lkw_r2 double precision,
  k_plz_r1 double precision,
  k_pkw_r1 double precision,
  k_lfw_r1 double precision,
  k_mot_r1 double precision,
  k_pma_r1 double precision,
  k_bus_r1 double precision,
  k_loa_r1 double precision,
  k_lzg_r1 double precision,
  k_sat_r1 double precision,
  k_son_r1 double precision,
  k_plz_r2 double precision,
  k_pkw_r2 double precision,
  k_lfw_r2 double precision,
  k_mot_r2 double precision,
  k_pma_r2 double precision,
  k_bus_r2 double precision,
  k_loa_r2 double precision,
  k_lzg_r2 double precision,
  k_sat_r2 double precision,
  k_son_r2 double precision
);
select create_hypertable('bast', 'datum');
comment on table bast is $$Dauerzählstellen auf Autobahnen und Bundesstraßen

Siehe https://www.bast.de/DE/Verkehrstechnik/Fachthemen/v2-verkehrszaehlung/Verkehrszaehlung.html?nn=1817946$$;
comment on column bast.tknr is 'Nummer des TK-Blattes';
comment on column bast.zst is 'BASt-Zählstellennummer';
comment on column bast.land is 'Bundesland';
comment on column bast.strklas is 'Straßenklasse';
comment on column bast.strnum is 'Straßennummer';
comment on column bast.datum is 'Datum';
comment on column bast.wotag is 'Wochentag (1: Montag, …, 7: Sonntag), optional';
comment on column bast.fahrtzw is 'Fahrtzweckgruppe (w: Werktag, u: Urlaubswerktag, s: Sonn- und Feiertag), optional';
comment on column bast.stunde is 'Erhebungsstunde (Stunde 01 ≡ 0.00 – 1.00 Uhr etc.), optional';
comment on column bast.kfz_r1 is 'Verkehrsmenge alle Kfz Richtung 1';
comment on column bast.kfz_r2 is 'Verkehrsmenge alle Kfz Richtung 2';
comment on column bast.lkw_r1 is 'Verkehrsmenge Lkw-Gruppe Richtung 1';
comment on column bast.lkw_r2 is 'Verkehrsmenge Lkw-Gruppe Richtung 2';
comment on column bast.plz_r1 is 'Verkehrsmenge Pkw-Gruppe (Pkw, Lfw, Mot) Richtung 1';
comment on column bast.pkw_r1 is 'Verkehrsmenge Pkw Richtung 1';
comment on column bast.lfw_r1 is 'Verkehrsmenge Lieferwagen Richtung 1';
comment on column bast.mot_r1 is 'Verkehrsmenge Motorräder Richtung 1';
comment on column bast.pma_r1 is 'Verkehrsmenge Pkw m. Anhänger Richtung 1';
comment on column bast.bus_r1 is 'Verkehrsmenge Bus Richtung 1';
comment on column bast.loa_r1 is 'Verkehrsmenge Lkw > 3,5t zGG ohne Anhänger Richtung 1';
comment on column bast.lzg_r1 is 'Verkehrsmenge Lkw > 3,5t zGG mit Anhänger (LmA) und Sattelzüge (Sat) Richtung 1';
comment on column bast.sat_r1 is 'Verkehrsmenge Sattelzüge Richtung 1';
comment on column bast.son_r1 is 'Verkehrsmenge sonstige Kfz (nicht klassifizierbare Kfz) Richtung 1';
comment on column bast.plz_r2 is 'Verkehrsmenge Pkw-Gruppe (Pkw, Lfw, Mot) Richtung 2';
comment on column bast.pkw_r2 is 'Verkehrsmenge Pkw Richtung 2';
comment on column bast.lfw_r2 is 'Verkehrsmenge Lieferwagen Richtung 2';
comment on column bast.mot_r2 is 'Verkehrsmenge Motorräder Richtung 2';
comment on column bast.pma_r2 is 'Verkehrsmenge Pkw m. Anhänger Richtung 2';
comment on column bast.bus_r2 is 'Verkehrsmenge Bus Richtung 2';
comment on column bast.loa_r2 is 'Verkehrsmenge Lkw > 3,5t zGG ohne Anhänger Richtung 2';
comment on column bast.lzg_r2 is 'Verkehrsmenge Lkw > 3,5t zGG mit Anhänger (LmA) und Sattelzüge (Sat) Richtung 2';
comment on column bast.sat_r2 is 'Verkehrsmenge Sattelzüge Richtung 2';
comment on column bast.son_r2 is 'Verkehrsmenge sonstige Kfz (nicht klassifizierbare Kfz) Richtung 2';
comment on column bast.k_kfz_r1 is 'Prüfkennziffer KFZ_R1';
comment on column bast.k_kfz_r2 is 'Prüfkennziffer KFZ_R2';
comment on column bast.k_lkw_r1 is 'Prüfkennziffer Lkw_R1';
comment on column bast.k_lkw_r2 is 'Prüfkennziffer Lkw_R2';
comment on column bast.k_plz_r1 is 'Prüfkennziffer PLZ_R1';
comment on column bast.k_pkw_r1 is 'Prüfkennziffer Pkw_R1';
comment on column bast.k_lfw_r1 is 'Prüfkennziffer Lfw_R1';
comment on column bast.k_mot_r1 is 'Prüfkennziffer Mot_R1';
comment on column bast.k_pma_r1 is 'Prüfkennziffer PmA_R1';
comment on column bast.k_bus_r1 is 'Prüfkennziffer Bus_R1';
comment on column bast.k_loa_r1 is 'Prüfkennziffer LoA_R1';
comment on column bast.k_lzg_r1 is 'Prüfkennziffer Lzg_R1';
comment on column bast.k_sat_r1 is 'Prüfkennziffer Sat_R1';
comment on column bast.k_son_r1 is 'Prüfkennziffer Son_R1';
comment on column bast.k_plz_r2 is 'Prüfkennziffer PLZ_R2';
comment on column bast.k_pkw_r2 is 'Prüfkennziffer Pkw_R2';
comment on column bast.k_lfw_r2 is 'Prüfkennziffer Lfw_R2';
comment on column bast.k_mot_r2 is 'Prüfkennziffer Mot_R2';
comment on column bast.k_pma_r2 is 'Prüfkennziffer PmA_R2';
comment on column bast.k_bus_r2 is 'Prüfkennziffer Bus_R2';
comment on column bast.k_loa_r2 is 'Prüfkennziffer LoA_R2';
comment on column bast.k_lzg_r2 is 'Prüfkennziffer Lzg_R2';
comment on column bast.k_sat_r2 is 'Prüfkennziffer Sat_R2';
comment on column bast.k_son_r2 is 'Prüfkennziffer Son_R2';
