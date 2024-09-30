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

CREATE OR REPLACE FUNCTION mgmt( TEXT ) RETURNS void AS
$$
BEGIN
  EXECUTE $1;
  NOTIFY pgrst, 'reload schema';
END;
$$ LANGUAGE plpgsql;

NOTIFY pgrst, 'reload schema';
