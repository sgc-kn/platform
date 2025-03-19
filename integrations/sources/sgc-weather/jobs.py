# platform: load=true

from utils.jobs import job, run_notebook


@job(group='sgc_weather', cron_schedule="27 * * * *")
def raw_tti_messages_v0():
    run_notebook("sync-raw-tti-messages-v0", relative_to=__file__)
