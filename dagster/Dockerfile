FROM python:3.11-slim

RUN apt-get update

RUN apt-get install -y --no-install-recommends curl

RUN pip install uv 

RUN uv pip install --system dagster==1.11.13 \
    dagster-dbt==0.27.13 \
    duckdb==1.4.0 \
    dbt-core==1.10.13 \
    dbt-duckdb==1.9.6 \
    dagster-duckdb==0.27.13 \
    dagster-webserver==1.11.13 \
    "pydantic<2.9.0" \
    "watchdog<5"

WORKDIR /

COPY dagster/definitions.py /definitions.py
COPY dagster/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h", "0.0.0.0", "-f", "/definitions.py", "-d", "/postcard_company"]