from dagster import Definitions, FilesystemIOManager, load_assets_from_modules

from . import assets

all_assets = load_assets_from_modules([assets])

defs = Definitions(
        assets=all_assets,
        resources={
            "fs_io_manager": FilesystemIOManager(),
            },
        )
