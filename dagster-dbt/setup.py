from setuptools import find_packages, setup

setup(
    name="postcard_company_dm",
    packages=find_packages(),
    install_requires=[
        "dagster==1.4.10",
        "dagster-dbt==0.20.10",
        "polars==0.18.15",
        "dbt-core==1.4.7",
        "dbt-duckdb==1.4.1",
        "dagster-duckdb==0.20.10",
        "dagster-duckdb-polars==0.20.10"
    ],
    extras_require={"dev": ["dagit", "pytest"]},
)
