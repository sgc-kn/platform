import dagster
import subprocess

@dagster.asset
def notebook() -> None:
    subprocess.run(['papermill',
                    dagster.file_relative_path(__file__, "notebook.ipynb"),
                    dagster.file_relative_path(__file__, "notebook-out.ipynb"),
                    '--log-output',
                    ], check=True)
    subprocess.run(['jupyter',
                    'nbconvert',
                    dagster.file_relative_path(__file__, "notebook-out.ipynb"),
                    '--to', 'html',
                    ], check=True)

    return dagster.MaterializeResult(
        metadata={
            "output": dagster.file_relative_path(__file__, "notebook-out.html")
        }
    )

job = dagster.define_asset_job(
        "dagster_ipynb_test", selection=[notebook]
)

schedule = dagster.ScheduleDefinition(
        job=job,
        cron_schedule="*/5 * * * *",
        default_status=dagster.DefaultScheduleStatus.RUNNING,
        )

from utils.dagster import registry as dagster_registry

dagster_registry.register(assets=[notebook], jobs=[job], schedules=[schedule])
