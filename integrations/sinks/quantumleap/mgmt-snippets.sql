-- show table metadata
SELECT table_name, entity_attrs FROM public.md_ets_metadata ORDER by table_name;

-- delete table and metadata
DO $$
DECLARE
  service TEXT;
  etype TEXT;
BEGIN
  service := 'nodered2';
  etype := 'raw_dwd_hourly';
  EXECUTE 'DELETE FROM md_ets_metadata WHERE table_name = ''"mt' || service || '"."et' || etype || '"''';
  EXECUTE 'DROP TABLE mt' || service || '.et' || etype;
END $$;
