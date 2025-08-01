# platform: load=true

from utils.jobs import job, run_notebook


@job(group='dwd', cron_schedule="*/5 * * * *") # every 5 minutes
def latest_measurements(context):
    run_notebook("warnmeldungen",
                 relative_to=__file__,
                 context=context)

