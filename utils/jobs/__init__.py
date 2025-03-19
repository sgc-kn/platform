from typing import Callable, Optional
from utils.dagster import registry as dagster_registry
import dagster
import os
import shutil
import subprocess
import tempfile

# Thin wrapper around dagster assets, jobs, and schedules to enable
# short definitions like the following.
#
# @job(group='test', cron_schedule='* * * * *')
# def hello():
#     print('hello')
#
# I'm aware that this might lead to reproducing functionality redundant with
# dagster. My intention is to make all our job definitions orthogonal to the
# choice of orchestrator. In other words, the redundancy is added to simplify
# replacing dagster in the future if need be.

def _job_definitions(
        func: Callable,
        *,
        name: str,
        group: str,
        cron_schedule: Optional[str] = None,
        ):
    dg_name = f'{group}_{name}'
    dg_assets = []
    dg_jobs = []
    dg_schedules = []

    @dagster.asset(name=dg_name)
    def asset(context):
        return func()
    dg_assets.append(asset)

    if cron_schedule is not None:
        job = dagster.define_asset_job(
                f"{name}_job",
                selection = [dg_name]
                )
        dg_jobs.append(job)

        schedule = dagster.ScheduleDefinition(
                job = job,
                cron_schedule = cron_schedule,
                )
        dg_schedules.append(schedule)

    return dagster.Definitions(
            assets = dg_assets,
            jobs = dg_jobs,
            schedules = dg_schedules,
            )

def job(*args, **kwargs):
    def decorator(func: Callable):
        defs = _job_definitions(func, *args, name=func.__name__, **kwargs)
        dagster_registry.register(defs)
        return None # intentionally no `defs` to hide dagster internals
    return decorator

## Additional wrapper schedule the evaluation of notebooks

def _evaluate_notebook(infile, outfile):
    # evaluate notebook infile (path), store result in outfile (path)
    # return true if the notebook evaluated alright, false otherwise
    try:
        subprocess.run(['papermill',
                        infile,
                        outfile,
                        '--log-output',
                        ], check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def _convert_notebook(ipynb):
    # render notebook ipynb (path) into html file, changing the extension from
    # ipynb to html. Raise on error.
    subprocess.run(['jupyter',
                    'nbconvert',
                    '--to', 'html',
                    ipynb
                    ], check=True)

def _evaluate_and_convert_notebook(src, dst):
    basename = os.path.basename(src)
    htmlname = os.path.splitext(basename)[0] + '.html'
    with tempfile.TemporaryDirectory() as tmp:
        tmpipynb = f'{tmp}/{basename}'
        tmphtml = f'{tmp}/{htmlname}'
        success = _evaluate_notebook(src, tmpipynb)

        _convert_notebook(tmpipynb)
        shutil.move(tmphtml, dst) # TODO persist this on S3

    if not success:
        raise RuntimeError("notebook evaluation failed. Find partially rendered notebook at: " + dst)

def run_notebook(notebook: str, *, relative_to: str):
    name = notebook.removesuffix('.ipynb')
    src = dagster.file_relative_path(relative_to, name + ".ipynb")
    dst = dagster.file_relative_path(relative_to, name + ".html")
    _evaluate_and_convert_notebook(src, dst)




