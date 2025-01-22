--
-- Extension Setup
--

-- CREATE SCHEMA extensions;
-- CREATE EXTENSION timescaledb SCHEMA extensions;
-- the timescale docker image does this for us!

-- CREATE EXTENSION postgis SCHEMA extensions;
-- not available on timescale base docker image

--
-- Setup schema for the API
--

CREATE SCHEMA postgrest;
SET search_path = postgrest, public;

--
-- Management Interface
-- execute arbitrary SQL from HTTP
--

DROP FUNCTION IF EXISTS configure_postgrest;

CREATE FUNCTION configure_postgrest()
RETURNS void AS $$
BEGIN
    -- Set db-schemas: postgrest, postgrest_*, ...
    PERFORM set_config('pgrst.db_schemas', STRING_AGG(schema_name, ', '), true)
    FROM (
      SELECT 'postgrest' as schema_name
      UNION ALL
      SELECT schema_name
      FROM information_schema.schemata
      WHERE schema_name LIKE 'postgrest_%'
    ) subquery;
END;
$$ LANGUAGE plpgsql;

SELECT configure_postgrest();

DROP FUNCTION IF EXISTS execute_many;

CREATE FUNCTION execute_many(
    statements TEXT[]
)
RETURNS VOID AS $$
DECLARE
    stmt TEXT;
BEGIN
    -- Start a transaction block
    BEGIN
        FOREACH stmt IN ARRAY statements LOOP
            EXECUTE stmt;
        END LOOP;
    EXCEPTION WHEN OTHERS THEN
        -- Rollback the transaction on any error
        RAISE EXCEPTION 'Transaction failed: %', SQLERRM;
        ROLLBACK;
    END;

    -- configure and reload
    PERFORM configure_postgrest();
    NOTIFY pgrst;
END;
$$ LANGUAGE plpgsql;
