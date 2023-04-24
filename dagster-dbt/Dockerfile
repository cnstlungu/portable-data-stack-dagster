FROM python:3.11

COPY dagster-dbt dagster-dbt

WORKDIR /dagster-dbt

RUN pip install -e ".[dev]"

WORKDIR /dagster-dbt/postcard_company_dm/dbt

RUN dbt deps

WORKDIR /dagster-dbt/postcard_company_dm