from setuptools import find_packages, setup

setup(
    name="postcard_company_dm",
    packages=find_packages(),
    install_requires=[
        "dagster",
        "dagster-dbt",
        "polars",
        "dbt-core",
        "dbt-duckdb",
        "dagster-duckdb",
        "dagster-duckdb-polars"
    ],
    extras_require={"dev": ["dagit", "pytest"]},
)
