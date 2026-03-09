#!/bin/bash
set -e

echo "Running dbt setup..."

cd /postcard_company
dbt deps
dbt seed
dbt compile

echo "Starting Dagster..."

# Forward CMD arguments to Dagster
exec dagster dev "$@"