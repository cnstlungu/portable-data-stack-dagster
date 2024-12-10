FROM python:3.11-slim

RUN apt-get update

RUN apt-get install -y --no-install-recommends curl

RUN pip install uv 

RUN uv pip install --system dagster==1.9.4 \
    dagster-dbt==0.25.4 \
    duckdb==1.1.2 \
    dbt-core==1.8.8 \
    dbt-duckdb==1.9.0 \
    dagster-duckdb==0.25.4 \
    dagster-webserver==1.9.4 \
    "pydantic<2.9.0" \
    "watchdog<5"

WORKDIR /postcard_company

RUN echo '#!/bin/bash\n\
    dagster-dbt project scaffold --project-name postcard_company_dm\n\
    dbt deps\n\
    dbt seed\n\
    dbt compile\n\
    cd /postcard_company/postcard_company_dm\n\
    exec dagster-webserver -h 0.0.0.0\n\
    ' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]