import dagster
import os
import shutil
import subprocess
import tempfile

def evaluate_notebook(infile, outfile):
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

def convert_notebook(ipynb):
    # render notebook ipynb (path) into html file, changing the extension from
    # ipynb to html. Raise on error.
    subprocess.run(['jupyter',
                    'nbconvert',
                    '--to', 'html',
                    ipynb
                    ], check=True)

def evaluate_and_convert_notebook(src, dst):
    basename = os.path.basename(src)
    htmlname = os.path.splitext(basename)[0] + '.html'
    with tempfile.TemporaryDirectory() as tmp:
        tmpipynb = f'{tmp}/{basename}'
        tmphtml = f'{tmp}/{htmlname}'
        success = evaluate_notebook(src, tmpipynb)

        convert_notebook(tmpipynb)
        shutil.move(tmphtml, dst)

    if not success:
        raise RuntimeError("notebook evaluation failed. Find partially rendered notebook at: " + dst)

@dagster.asset
def notebook():
    name = "notebook"
    src = dagster.file_relative_path(__file__, name + ".ipynb")
    dst = dagster.file_relative_path(__file__, name + ".html")
    evaluate_and_convert_notebook(src, dst)
    output = dagster.MetadataValue.url('file://' + dst)
    return dagster.MaterializeResult(
        metadata={
            "output": output,
        }
    )

job = dagster.define_asset_job(
        "dagster_ipynb_test", selection=[notebook]
)

schedule = dagster.ScheduleDefinition(
        job=job,
        cron_schedule="*/5 * * * *",
        #  default_status=dagster.DefaultScheduleStatus.RUNNING,
        )

from utils.dagster import registry as dagster_registry

dagster_registry.register(assets=[notebook], jobs=[job], schedules=[schedule])
