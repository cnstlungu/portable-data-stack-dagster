FROM apache/superset:2.0.1 

ARG SUPERSET_ADMIN
ARG SUPERSET_PASSWORD
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
# Switching to root to install the required packages
USER root
COPY --chown=superset:superset ./superset/assets .
RUN pip install psycopg2-binary
RUN pip install duckdb-engine
RUN pip install duckdb
USER superset
RUN superset fab create-admin \
              --username ${SUPERSET_ADMIN} \
              --firstname Superset \
              --lastname Admin \
              --email admin@example.com \
              --password ${SUPERSET_PASSWORD}
RUN superset db upgrade
RUN superset init
RUN superset set_database_uri -d OLTP  -u postgresql+psycopg2://${POSTGRES_USER}:${POSTGRES_PASSWORD}@oltp:5432/sales_oltp
RUN superset set_database_uri -d DW  -u duckdb:///superset_home/db/datamart.duckdb
RUN superset import-dashboards -p ./dashboard.json