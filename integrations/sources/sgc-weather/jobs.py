# platform: load=true

from utils.jobs import job, run_notebook


@job(group='sgc_weather', cron_schedule="27 * * * *") # hourly, xx:27
def raw_tti_messages(context):
    run_notebook("sync-raw-tti-messages",
                 relative_to=__file__,
                 context=context)

@job(group='sgc_weather', cron_schedule="0 0 * * *") # daily, 00:00
def maintain_tables(context):
    run_notebook("maintain-tables",
                 relative_to=__file__,
                 context=context)
