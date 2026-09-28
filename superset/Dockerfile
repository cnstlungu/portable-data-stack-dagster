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

# No credential reaches a layer. The Superset CLI refuses to run under its
# default SECRET_KEY, so these two schema commands get a throwaway one inline -
# it is never written to the image, and neither command stores anything
# encrypted with it. The DW connection, which Superset does encrypt, and the
# admin account are created at container start by entrypoint.sh using the real
# key from the environment. As build ARGs they showed up in `docker history`.
RUN SUPERSET_SECRET_KEY=schema-migration-only superset db upgrade
RUN SUPERSET_SECRET_KEY=schema-migration-only superset init

ENTRYPOINT ["/app/entrypoint.sh"]
