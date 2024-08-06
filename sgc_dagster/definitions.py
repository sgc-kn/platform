from dagster import Definitions, FilesystemIOManager, load_assets_from_modules

from . import assets
from . import lubw

all_assets = load_assets_from_modules([assets])

defs = Definitions(
        assets=all_assets,
        jobs=[lubw.lubw],
        resources={
            "fs_io_manager": FilesystemIOManager(),
            },
        )
