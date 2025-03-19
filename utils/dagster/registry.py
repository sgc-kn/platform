from dagster import Definitions


class Registry:
    def __init__(self):
        self.definitions_list = []

    def register(self, defs):
        self.definitions_list.append(defs)

    def definitions(self):
        return Definitions.merge(*self.definitions_list)

registry = Registry()


def register(*args, **kwargs):
    registry.register(*args, **kwargs)
