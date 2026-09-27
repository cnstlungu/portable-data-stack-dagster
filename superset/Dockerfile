FROM apache/superset:4.1.1

# Switching to root to install the required packages
USER root

RUN pip install uv

COPY --chown=superset:superset ./superset/assets .
COPY ./superset/requirements.txt /tmp/requirements.txt
RUN uv pip install --system -r /tmp/requirements.txt
COPY --chown=superset:superset ./superset/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
USER superset

# Nothing below this line takes a credential. The admin account is created at
# container start by entrypoint.sh: a build ARG would be recorded in the image
# and readable with `docker history`.
RUN superset db upgrade
RUN superset init
RUN superset set_database_uri -d DW  -u duckdb:///superset_home/db/datamart.duckdb

ENTRYPOINT ["/app/entrypoint.sh"]
