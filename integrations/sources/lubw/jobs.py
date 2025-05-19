# platform: load=true

from utils.jobs import job, run_notebook
import datetime


@job(group='lubw', cron_schedule="17 4 * * *") # daily, 04:17
def latest_measurements(context):
    run_notebook("sync-latest",
                 relative_to=__file__,
                 context=context)

this_year = datetime.date.today().year
years = [str(x) for x in range(2008, this_year + 1)]

@job(group='lubw', partition=years)
def historic_measurements(context):
    year = int(context.partition_key)
    run_notebook("backfill",
                 relative_to=__file__,
                 context=context,
                 parameters=dict(year=year))

@job(group='lubw', cron_schedule="17 5 * * sun") # sunday 05:17
def maintenance(context):
    run_notebook("maintain-delta-table",
                 relative_to=__file__,
                 context=context)

@job(group='lubw', partition=years, depends_on=[historic_measurements])
def publish_historic_measurements(context):
    year = int(context.partition_key)
    run_notebook("push-hourly-to-public-s3",
                 relative_to=__file__,
                 context=context,
                 parameters=dict(year=year))

@job(group='lubw', cron_schedule="22 4 * * *") # daily, 04:22
def publish_latest_measurements(context):
    run_notebook("push-hourly-to-public-s3",
                 relative_to=__file__,
                 context=context,
                 parameters=dict(year=this_year))

@job(group='lubw', cron_schedule="22 4 1 1 *") # Jan 1, 04:22
def publish_latest_measurements_of_last_year(context):
    run_notebook("push-hourly-to-public-s3",
                 relative_to=__file__,
                 context=context,
                 parameters=dict(year=this_year - 1))