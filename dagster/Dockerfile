FROM python:3.11-slim

RUN apt-get update

RUN apt-get install -y --no-install-recommends curl

RUN pip install uv 

RUN uv pip install --system dagster==1.9.13 \
    dagster-dbt==0.25.13 \
    duckdb==1.2.0 \
    dbt-core==1.9.2 \
    dbt-duckdb==1.9.1 \
    dagster-duckdb==0.25.13 \
    dagster-webserver==1.9.13 \
    "pydantic<2.9.0" \
    "watchdog<5"

WORKDIR /postcard_company

RUN echo '#!/bin/bash\n\
    dagster-dbt project scaffold --project-name postcard_company_dm\n\
    dbt deps\n\
    dbt seed\n\
    dbt compile\n\
    cd /postcard_company/postcard_company_dm\n\
    exec dagster dev -h 0.0.0.0\n\
    ' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]