FROM python:3.11-slim

RUN apt-get update

RUN apt-get install -y --no-install-recommends curl

RUN apt-get install -y git make automake gcc g++ subversion

RUN pip install uv 

RUN git clone -n --depth=1 --filter=tree:0 https://github.com/cnstlungu/postcard-company-datamart.git /dbt_project

WORKDIR /dbt_project

RUN git sparse-checkout set --no-cone postcard_company

RUN git checkout

WORKDIR /dbt_project/postcard_company

RUN uv pip install --system dagster==1.9.4 \
    dagster-dbt==0.25.4 \
    duckdb==1.1.2 \
    dbt-core==1.8.8 \
    dbt-duckdb==1.9.0 \
    dagster-duckdb==0.25.4 \
    dagster-webserver==1.9.4 \
    "pydantic<2.9.0" \
    "watchdog<5"

RUN dagster-dbt project scaffold --project-name postcard_company_dm

RUN echo '#!/bin/bash\n\

dbt deps\n\
dbt seed\n\
dbt compile\n\
cd /dbt_project/postcard_company/postcard_company_dm\n\
exec dagster-webserver -h 0.0.0.0\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]