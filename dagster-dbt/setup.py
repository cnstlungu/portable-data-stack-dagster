from setuptools import find_packages, setup

setup(
    name="postcard_company_dm",
    packages=find_packages(),
    install_requires=[
        "dagster==1.6.6",
        "dagster-dbt==0.22.6",
        "duckdb==0.10.0",
        "dbt-core==1.7.8",
        "dbt-duckdb==1.7.2",
        "dagster-duckdb==0.22.6"
    ],
    extras_require={"dev": ["dagit", "pytest"]},
)
