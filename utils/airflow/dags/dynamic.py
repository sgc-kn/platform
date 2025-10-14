from pathlib import Path
import utils.jobs as jobs
import importlib.util, sys

from airflow import DAG
from airflow.operators.python import PythonOperator, get_current_context

# TODO quite similar code should already exist for the dagster code location; refactor?

FILE = Path(__file__)             # .../platform/utils/airflow/dags/dynamic.py
ROOT = FILE.resolve().parents[3]  # .../platform
PATH = ROOT / "integrations"      # .../platform/integrations

def _import_jobs_modules():
    if not PATH.exists():
        print(f"[dag_loader] No SOURCES_DIR at {SOURCES_DIR}, skipping.")
        return
    for jobs_file in PATH.glob("**/jobs.py"):
        text = jobs_file.read_text(encoding="utf-8", errors="ignore")
        if "# platform: load=true" not in text:
            continue
        mod_name = "int_" + "_".join(jobs_file.relative_to(ROOT).with_suffix("").parts)
        spec = importlib.util.spec_from_file_location(mod_name, jobs_file)
        if spec and spec.loader:
            module = importlib.util.module_from_spec(spec)
            sys.modules[mod_name] = module
            spec.loader.exec_module(module)
            print(f"[dag_loader] Loaded {jobs_file}")

_import_jobs_modules()

for job in jobs.get_registry():
   dag = jobs.build_dag_for_job(job)
   globals()[dag.dag_id] = dag
   print(f"[dag_loader] Registered DAG: {dag.dag_id}")
