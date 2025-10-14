# This is repo/utils/airflow/dags/utils/job.py and linked to
# AIRFLOW_HOME/dags/utils/jobs.py . It seems this is loaded instead of
# repo/utils/jobs/__init__.py when Airflow loads this file.

from __future__ import annotations
from dataclasses import dataclass
from datetime import timedelta
from pathlib import Path
from typing import Callable, Dict, List, Optional
from airflow import DAG
from airflow.operators.python import PythonOperator, get_current_context
import inspect

# In-memory registry
_REGISTRY: List["JobDef"] = []

@dataclass
class JobDef:
    func: Callable
    group: str
    cron_schedule: Optional[str]
    tags: List[str]
    default_args: Dict

def job(group: str,
        cron_schedule: Optional[str] = None,
        tags: Optional[List[str]] = None,
        default_args: Optional[Dict] = None,
        partition : Any = None, # compatibility with dagster jobs
        depends_on : Any = None, # compatibility with dagster jobs
        ):
    """
    Register a job function that accepts a single argument: context
    """
    def _decorator(func: Callable):
        _REGISTRY.append(
            JobDef(
                func=func,
                group=group,
                cron_schedule=cron_schedule,
                tags=tags or [],
                default_args=default_args or {"retries": 1, "retry_delay": timedelta(minutes=5)},
            )
        )
        return func
    return _decorator

def _resolve_notebook(notebook_name: str, relative_to: str) -> Path:
    # Walk upwards until we find the repo root containing 'integrations'
    # start = Path(relative_to).resolve()
    # candidates = [start] + list(start.parents)
    # root = next((p for p in candidates if (p / "integrations").exists()), None)
    # if not root:
    #     raise FileNotFoundError("Could not locate 'integrations' directory.")
    dir = Path(relative_to).resolve().parent
    nb = Path(dir / f"{notebook_name}.ipynb").resolve()
    if not nb.exists():
        raise FileNotFoundError(f"Notebook not found: {nb}")
    return nb

def run_notebook(notebook_name: str, *, relative_to: str, context, parameters: Optional[Dict]=None,
                 out_dir: Optional[str] = None) -> str:
    """
    Execute the notebook at <notebook_name>.ipynb
    Returns path to the executed notebook (also pushed to XCom via return value).
    """
    # Lazy import so scheduler parsing stays fast & cheap
    import papermill as pm

    nb_in = _resolve_notebook(notebook_name, relative_to)
    dag_id = context["dag"].dag_id
    run_id = context["run_id"]
    out_dir = Path(out_dir or f"/opt/airflow/notebooks/{dag_id}")
    out_dir.mkdir(parents=True, exist_ok=True)
    out_nb = out_dir / f"{run_id}.ipynb"

    base_params = {
        # Common Airflow context you usually want in a notebook:
        "dag_id": dag_id,
        "task_id": context["task"].task_id if "task" in context else "run",
        "run_id": run_id,
        "logical_date": str(context["logical_date"]),
        "data_interval_start": str(context["data_interval_start"]),
        "data_interval_end": str(context["data_interval_end"]),
        # Also pass DAG params (if any)
        **(context.get("params") or {}),
    }
    if parameters:
        base_params.update(parameters)

    pm.execute_notebook(
        input_path=str(nb_in),
        output_path=str(out_nb),
        parameters=base_params,
    )
    return str(out_nb)

def get_registry() -> List[JobDef]:
    return list(_REGISTRY)

def build_dag_for_job(j: JobDef) -> DAG:
    dag_id = f"{j.group}.{j.func.__name__}"

    # Build a single-task DAG that calls your job function with current context
    with DAG(
        dag_id=dag_id,
        schedule=j.cron_schedule,
        catchup=False,
        tags=[j.group] + j.tags,
        default_args=j.default_args,
    ) as dag:

        def _wrapped_callable():
            ctx = get_current_context()  # official way to fetch context in Airflow 2/3
            return j.func(context=ctx)

        PythonOperator(
            task_id="run",
            python_callable=_wrapped_callable,
            execution_timeout=timedelta(hours=2),
        )

    return dag
