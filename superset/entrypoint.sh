#!/usr/bin/env bash
# Superset first-run setup.
#
# The admin account used to be created in the Dockerfile from build ARGs, and
# the DW connection was registered there too. Build args are recorded in image
# metadata, so `docker history` handed the username, the password and the
# signing key to anyone who pulled or rebuilt the image. Everything that needs
# a credential happens here instead, at container start, from the environment.
set -euo pipefail

: "${SUPERSET_ADMIN:?is not set - copy .env.example to .env}"
: "${SUPERSET_PASSWORD:?is not set - copy .env.example to .env}"
: "${SUPERSET_SECRET_KEY:?is not set - copy .env.example to .env}"

if [ "${SUPERSET_SECRET_KEY}" = "ChangeMeToARandomStringChangeMeToARandomStringChangeMeTo" ]; then
    echo "WARNING: SUPERSET_SECRET_KEY is still the placeholder from .env.example." >&2
    echo "         It signs session cookies and every fork of this repo knows it." >&2
    echo "         Before the stack is reachable by anyone else, put your own in" >&2
    echo "         .env:  openssl rand -base64 42" >&2
fi

# Superset encrypts stored connection URIs with SECRET_KEY, so this has to run
# with the same key the server will use - which is why it is here and not in
# the image.
superset set_database_uri -d DW -u duckdb:///superset_home/db/datamart.duckdb

if superset fab list-users 2>/dev/null | grep -qE "username:${SUPERSET_ADMIN}([^[:alnum:]_]|\$)"; then
    echo "Superset admin '${SUPERSET_ADMIN}' already exists; leaving it alone."
else
    superset fab create-admin \
        --username "${SUPERSET_ADMIN}" \
        --firstname Superset \
        --lastname Admin \
        --email admin@example.com \
        --password "${SUPERSET_PASSWORD}"
fi

# This was a compose post_start hook. Hooks fire once the container is up, with
# no ordering against the entrypoint, so with the account and the connection
# created here the import could have raced both.
if [ -f /app/dashboard.zip ]; then
    superset import-dashboards -p /app/dashboard.zip -u "${SUPERSET_ADMIN}" \
        || echo "Dashboard import did not succeed - already imported? Continuing." >&2
fi

exec "$@"
