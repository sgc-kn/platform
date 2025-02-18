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

--
-- Job Queue for long running tasks
--

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs (
    id SERIAL PRIMARY KEY,
	task JSONB NOT NULL,
    error JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    claimed_at TIMESTAMPTZ,
	released_at TIMESTAMPTZ
);

DROP FUNCTION IF EXISTS process_task(task JSONB);
CREATE OR REPLACE FUNCTION process_task(task JSONB) RETURNS void AS $$
DECLARE
	statements TEXT[];
BEGIN
    IF task ? 'statements' THEN
		SELECT array_agg(elem::TEXT) 
		INTO statements 
		FROM jsonb_array_elements_text(task->'statements') AS elem;
		PERFORM execute_many(statements);
    ELSE
	    RAISE EXCEPTION USING MESSAGE = 'invalid task', HINT = 'set statements key';
    END IF;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS process_pending_job;
CREATE OR REPLACE FUNCTION process_pending_job() RETURNS INT AS $$
DECLARE
    job_id INT;
    task_data JSONB;
    error_message TEXT;
    error_hint TEXT;
    error_detail TEXT;
    error_json JSONB;
BEGIN
    -- Lock and fetch the first pending job
    SELECT id, task INTO job_id, task_data
    FROM jobs
    WHERE claimed_at IS NULL
    ORDER BY created_at
    LIMIT 1
    FOR UPDATE SKIP LOCKED;

    -- If no job is found, exit
    IF job_id IS NULL THEN
        RETURN NULL;
    END IF;

    -- Mark the job as claimed
    UPDATE jobs SET claimed_at = clock_timestamp() WHERE id = job_id;

    -- Attempt to process the task using the existing process_task function
    BEGIN
        PERFORM process_task(task_data);

        -- Mark job as completed (success)
        UPDATE jobs SET released_at = clock_timestamp() WHERE id = job_id;
    EXCEPTION
        -- Capture exception details separately
        WHEN others THEN
            GET STACKED DIAGNOSTICS 
                error_message = MESSAGE_TEXT,
                error_hint = PG_EXCEPTION_HINT,
                error_detail = PG_EXCEPTION_DETAIL;

            -- Construct JSONB object for error
            error_json = jsonb_build_object(
                'message', error_message,
                'hint', COALESCE(error_hint, ''),
                'detail', COALESCE(error_detail, '')
            );

            -- Mark job as completed (failed) with error details
            UPDATE jobs SET released_at = clock_timestamp(), error = error_json WHERE id = job_id;
    END;
	
	RETURN job_id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS process_pending_jobs;
CREATE OR REPLACE FUNCTION process_pending_jobs() RETURNS INT AS $$
DECLARE
    job_id INT;
    job_count INT := 0;
BEGIN
    LOOP
        -- Process the next available job
        job_id := process_pending_job();
        
        -- If no job was processed, exit the loop
        IF job_id IS NULL THEN
            EXIT;
        END IF;
        
        -- Increment the job count
        job_count := job_count + 1;
    END LOOP;
    
    RETURN job_count;
END;
$$ LANGUAGE plpgsql;