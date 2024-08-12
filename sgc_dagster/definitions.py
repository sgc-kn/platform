from .registry import registry

from .sources.lubw import dagster
from .sources.lubw import dagster_historic

defs = registry.definitions()
