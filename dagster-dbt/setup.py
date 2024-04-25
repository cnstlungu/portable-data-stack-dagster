from setuptools import find_packages, setup

setup(
    name="postcard_company_dm",
    packages=find_packages(),
    install_requires=[
        "dagster==1.7.3",
        "dagster-dbt==0.23.3",
        "duckdb==0.10.2",
        "dbt-core==1.7.13",
        "dbt-duckdb==1.7.4",
        "dagster-duckdb==0.23.3"
    ],
    extras_require={"dev": ["dagit", "pytest"]},
)
