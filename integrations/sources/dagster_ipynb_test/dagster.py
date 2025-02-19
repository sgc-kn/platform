import dagster
import dagstermill

asset = dagstermill.define_dagstermill_asset(
    name="notebook_asset",
    notebook_path=dagster.file_relative_path(__file__, "notebook.ipynb"),
    group_name="dagster_ipynb_test",
)

job = dagster.define_asset_job(
        "dagster_ipynb_test", selection=[asset]
)

schedule = dagster.ScheduleDefinition(
        job=job,
        cron_schedule="*/5 * * * *",
        default_status=dagster.DefaultScheduleStatus.RUNNING,
        )

from utils.dagster import registry as dagster_registry

dagster_registry.register(assets=[asset], jobs=[job], schedules=[schedule])
