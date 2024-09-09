from setuptools import find_packages, setup

setup(
    name="postcard_company_dm",
    packages=find_packages(),
    install_requires=[
        "dagster==1.7.9",
        "dagster-dbt==0.23.9",
        "duckdb==1.0.0",
        "dbt-core==1.8.2",
        "dbt-duckdb==1.8.1",
        "dagster-duckdb==0.23.9",
        "pydantic<2.9.0"
    ],
    extras_require={"dev": ["dagit", "pytest"]},
)
