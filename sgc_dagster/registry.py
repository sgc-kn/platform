from dagster import Definitions

class Registry():
    def __init__(self):
        self.assets = []
        self.asset_checks = []
        self.schedules = []
        self.sensors = []
        self.jobs = []

    def register(self, *,
                 assets = [],
                 asset_checks = [],
                 schedules = [],
                 sensors = [],
                 jobs = []):
        self.assets += assets
        self.asset_checks += asset_checks
        self.schedules += schedules
        self.sensors += sensors
        self.jobs += jobs

    def definitions(self, *, resources=None, executor=None, loggers=None):
        return Definitions(
                assets = self.assets,
                asset_checks = self.asset_checks,
                schedules = self.schedules,
                sensors = self.sensors,
                jobs = self.jobs,
                resources = resources,
                executor = executor,
                loggers = loggers
                )

registry = Registry()

def register(*args, **kwargs):
    registry.register(*args, **kwargs)
