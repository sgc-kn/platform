from typing import Callable, Optional
from utils.dagster import registry as dagster_registry
import dagster
import os
import shutil
import subprocess
import sys
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
        return func(context)
    dg_assets.append(asset)

    if cron_schedule is not None:
        job = dagster.define_asset_job(
                f"{dg_name}_job",
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

def _evaluate_notebook(infile, outfile, context):
    # evaluate notebook infile (path), store result in outfile (path)
    # return true if the notebook evaluated alright, false otherwise
    prc = subprocess.Popen(
            [
                'papermill',
                infile,
                outfile,
                '--log-output',
                ],
            stdout = subprocess.PIPE,
            stderr = subprocess.STDOUT,
            text = True,
            )

    # sys.stderr is not captured by dagster on k8s
    for ln in prc.stdout:
        context.log.info(ln)

    prc.communicate() # wait for returncode
    if prc.returncode > 0:
        context.log.error(f'papermill return code: {prc.returncode}')
        return False
    else:
        return True

def _convert_notebook(ipynb):
    # render notebook ipynb (path) into html file, changing the extension from
    # ipynb to html. Raise on error.
    subprocess.run(['jupyter',
                    'nbconvert',
                    '--to', 'html',
                    ipynb
                    ], check=True)

def _evaluate_and_convert_notebook(src, dst, context):
    basename = os.path.basename(src)
    htmlname = os.path.splitext(basename)[0] + '.html'
    with tempfile.TemporaryDirectory() as tmp:
        tmpipynb = f'{tmp}/{basename}'
        tmphtml = f'{tmp}/{htmlname}'
        success = _evaluate_notebook(src, tmpipynb, context)

        _convert_notebook(tmpipynb)
        shutil.move(tmphtml, dst) # TODO persist this on S3

    if not success:
        raise RuntimeError("notebook evaluation failed. Find partially rendered notebook at: " + dst)

def run_notebook(notebook: str, *, relative_to: str, context):
    name = notebook.removesuffix('.ipynb')
    src = dagster.file_relative_path(relative_to, name + ".ipynb")
    dst = dagster.file_relative_path(relative_to, name + ".html")
    _evaluate_and_convert_notebook(src, dst, context)




