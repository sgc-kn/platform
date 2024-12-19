## We could import the relevant modules manually like this:

# from integrations.sources.lubw import incremental_sync_job
# from integrations.sources.lubw import monthly_asset

## Instead we search and import the modules automatically

import importlib
import os


def is_dagster_module(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
        return "dagster_registry.register(" in content


def find_dagster_modules(package):
    def filter(name):
        return not (name.startswith("_") or name.startswith("."))

    spec = importlib.util.find_spec(package)
    for p in spec.submodule_search_locations:
        if not filter(p):
            continue

        for root, dirs, files in os.walk(p, topdown=True):
            dirs[:] = [d for d in dirs if filter(d)]

            for f in files:
                if not filter(f) or not f.endswith(".py"):
                    continue

                path = root + "/" + f
                if not is_dagster_module(path):
                    continue

                relative = os.path.relpath(path, p)
                module_name = relative.replace(os.path.sep, ".")  # Replace /
                module_name = module_name[:-3]  # Remove ".py"

                yield (relative, package + "." + module_name)


def full_module_name(base, path):
    relative_path = os.path.relpath(path, base_path)
    module_name = relative_path.replace(os.path.sep, ".")[:-3]  # Remove ".py"
    return f"{package_name}.{module_name}"


def import_dagster_modules(package):
    for p, m in find_dagster_modules(package):
        # print(f"import dagster module {m}")
        importlib.import_module(m)


import_dagster_modules("integrations")


## The imported modules have registered themselves

from .registry import registry

defs = registry.definitions()
