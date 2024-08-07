import dagster

from .sources.lubw.dagster import job as lubw_job

defs = dagster.Definitions( jobs=[ lubw_job ] )
