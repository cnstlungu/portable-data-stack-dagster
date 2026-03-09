FROM apache/superset:4.1.1

ARG SUPERSET_ADMIN
ARG SUPERSET_PASSWORD
ARG SUPERSET_SECRET_KEY
# Switching to root to install the required packages
USER root

RUN pip install uv

COPY --chown=superset:superset ./superset/assets .
RUN uv pip install --system duckdb-engine==0.17.0 duckdb==1.4.4
USER superset
RUN superset fab create-admin \
              --username ${SUPERSET_ADMIN} \
              --firstname Superset \
              --lastname Admin \
              --email admin@example.com \
              --password ${SUPERSET_PASSWORD}
RUN superset db upgrade
RUN superset init
RUN superset set_database_uri -d DW  -u duckdb:///superset_home/db/datamart.duckdb