# platform: load=true

from utils.jobs import job, run_notebook


@job(group='lubw', cron_schedule="17 4 * * *") # daily, 04:17
def latest_measurements(context):
    run_notebook("sync-latest",
                 relative_to=__file__,
                 context=context)
    
@job(group='lubw')
def historic_measurements(context):
    run_notebook("backfill",
                 relative_to=__file__,
                 context=context)

@job(group='lubw', cron_schedule="17 5 * * sun") # sunday 05:17
def maintenance(context):
    run_notebook("maintain-delta-table",
                 relative_to=__file__,
                 context=context)