-- SQL snippets to handle lubw data in QuantumLeap

-- starting point: we've uploaded the historic raw data to quantum leap using
-- monthly_upload.ipynb
--
-- goal: we want to merge the historic data into the production tables

-- set fiware service
SET search_path to mtnodered3;

-- fix entity_id in raw table
UPDATE etraw_lubw
SET entity_id = regexp_replace(entity_id, 'uri:raw:', 'urn:raw:')
WHERE entity_id LIKE 'uri:raw:%';

-- create sdm table from existing prod table
CREATE TABLE etairqualityobserved (LIKE mtlubw.etairqualityobserved INCLUDING ALL);

-- map raw data into sdm table
INSERT INTO etairqualityobserved(
  entity_id,
  entity_type,
  time_index,
	fiware_servicepath,
	__original_ngsi_entity__,
	dateprocessed,
	dateobserved,
	"location",
	location_centroid,
	no2,
	o3,
	pm10,
	pm25
  )
SELECT DISTINCT
	regexp_replace(
    raw.entity_id,
    'urn:raw:lubw:',
    'urn:sdm:AirQualityObserved:lubw:'
    ) as entity_id,
	'AirQualityObserved' as entity_type,
	raw.time_index,
	fiware_servicepath,
	__original_ngsi_entity__,
	dateprocessed,
	startZeit as dateobserved,
	"location",
	location_centroid,
	no2,
	o3,
	pm10,
	pm25
FROM etraw_lubw raw
LEFT JOIN (
  SELECT entity_id, time_index, wert as no2
  FROM etraw_lubw
  WHERE entity_id LIKE '%:no2'
  ) no2
  ON raw.entity_id = no2.entity_id
  AND raw.time_index = no2.time_index
LEFT JOIN (
  SELECT entity_id, time_index, wert as o3
  FROM etraw_lubw
  WHERE entity_id LIKE '%:o3'
  ) o3
  ON raw.entity_id = o3.entity_id
  AND raw.time_index = o3.time_index
LEFT JOIN (
  SELECT entity_id, time_index, wert as pm10
  FROM etraw_lubw WHERE entity_id LIKE '%:pm10'
  ) pm10
  ON raw.entity_id = pm10.entity_id
  AND raw.time_index = pm10.time_index
LEFT JOIN (
  SELECT entity_id, time_index, wert as pm25
  FROM etraw_lubw
  WHERE entity_id LIKE '%:pm25'
  ) pm25
  ON raw.entity_id = pm25.entity_id
  AND raw.time_index = pm25.time_index
CROSS JOIN (
  SELECT "location", location_centroid
  FROM mtlubw.etairqualityobserved LIMIT 1
  ) loc
ORDER BY time_index DESC;

-- get minimum date in prod tables
SELECT min(time_index) FROM mtlubw.etairqualityobserved;
SELECT min(time_index) FROM mtlubw.etraw_lubw;

-- copy historic raw data from test to prod
INSERT INTO mtlubw.etraw_lubw(
  entity_id,
  entity_type,
  time_index,
  fiware_servicepath,
  __original_ngsi_entity__,
  dateprocessed,
  startzeit,
  endzeit,
  wert,
  station,
  komponente
  )
SELECT DISTINCT
  entity_id,
  entity_type,
  time_index,
  fiware_servicepath,
  __original_ngsi_entity__,
  dateprocessed,
  startzeit,
  endzeit,
  wert,
  station,
  komponente
FROM etraw_lubw
WHERE time_index < '2024-08-11 09:00:00+00';

-- copy historic sdm data from test to prod
INSERT INTO mtlubw.etairqualityobserved(
  entity_id,
  entity_type,
  time_index,
	fiware_servicepath,
	__original_ngsi_entity__,
	dateprocessed,
	dateobserved,
	"location",
	location_centroid,
	no2,
	o3,
	pm10,
	pm25
  )
SELECT
  entity_id,
  entity_type,
  time_index,
	fiware_servicepath,
	__original_ngsi_entity__,
	dateprocessed,
	dateobserved,
	"location",
	location_centroid,
	no2,
	o3,
	pm10,
	pm25
FROM etairqualityobserved
WHERE time_index < '2024-08-11 09:00:00+00';
