import os

from dagster_dbt import dbt_cli_resource, dbt_test_op, load_assets_from_dbt_project

from dagster import Definitions, file_relative_path
from dagster import job

DBT_PROJECT_PATH = file_relative_path(__file__, "../dbt")
DBT_PROFILES = file_relative_path(__file__, "../dbt/config")


dbt_resource = dbt_cli_resource.configured(
        {
            "project_dir": DBT_PROJECT_PATH,
            "profiles_dir": DBT_PROFILES,
        }
    )

model_resources = {
    "dbt": dbt_resource
}



@job(resource_defs={'dbt': dbt_resource})
def run_dbt_test_job():
    dbt_test_op()

defs = Definitions(assets=load_assets_from_dbt_project(DBT_PROJECT_PATH, profiles_dir=DBT_PROFILES, use_build_command=True), resources=model_resources, jobs=[run_dbt_test_job])

