# platform: load=true

from utils.jobs import job, run_notebook

@job(group='mastr', cron_schedule="16 6 * * *") # daily, 06:16
def getOeffentlicheStromerzeugung(context):
    run_notebook("erweiterteoeffentlicheeinheitstromerzeugung",
                 relative_to=__file__,
                 context=context)