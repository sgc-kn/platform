from dagstermill import define_dagstermill_asset
from dagster import file_relative_path

asset = define_dagstermill_asset(
    name="notebook_asset",
    notebook_path=file_relative_path(__file__, "notebook.ipynb"),
    group_name="dagster_ipynb_test",
)

from utils.dagster import registry as dagster_registry

dagster_registry.register(assets=[asset])
