from pathlib import Path

from dagster import Definitions, AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

# Paths inside the container
DBT_PROJECT_DIR = Path("/postcard_company")
DBT_PROFILES_DIR = Path("/postcard_company")  # you have profiles.yml there

# dbt CLI resource Dagster will use to run dbt
dbt_resource = DbtCliResource(
    project_dir=str(DBT_PROJECT_DIR),
    profiles_dir=str(DBT_PROFILES_DIR),
)

# dbt manifest produced by `dbt compile` or `dbt build`
MANIFEST_PATH = DBT_PROJECT_DIR / "target" / "manifest.json"


@dbt_assets(manifest=MANIFEST_PATH)
def postcard_company_dbt_assets(
    context: AssetExecutionContext,
    dbt: DbtCliResource,
):
    # You can change to ["run"], ["test"], etc.
    yield from dbt.cli(["build"], context=context).stream()


defs = Definitions(
    assets=[postcard_company_dbt_assets],
    resources={"dbt": dbt_resource},
)