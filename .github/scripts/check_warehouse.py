"""Wait for the pipeline to fill the warehouse, then check what it wrote.

Meant to be piped into a container that has duckdb and the shared volume:

    docker compose exec -T <service> python - < .github/scripts/check_warehouse.py

fact_sales holds one row per source transaction, so the expected count is the
three sales feeds added up. Reading that off the parquet files rather than
hardcoding it keeps the check honest when N_TRANSACTIONS changes, and makes it
a real invariant rather than a number someone has to remember to update.
"""

import os
import sys
import time

import duckdb

WAREHOUSE = os.environ.get("DUCKDB_FILE_PATH", "/shared/db/datamart.duckdb")
PARQUET = os.environ.get("INPUT_FILES_PATH", "/shared/parquet")
FEEDS = ("main", "resellers_type1", "resellers_type2")
TIMEOUT = int(os.environ.get("CHECK_TIMEOUT_SECONDS", "900"))


def expected_rows():
    con = duckdb.connect()
    try:
        return sum(
            con.execute(
                f"select count(*) from read_parquet('{PARQUET}/{feed}.parquet')"
            ).fetchone()[0]
            for feed in FEEDS
        )
    finally:
        con.close()


def fact_rows():
    """Largest row count of any fact_sales in the warehouse, or None.

    The schema is looked up rather than assumed, because the engines across
    these repos do not name it alike. information_schema covers views as well
    as tables, which matters for SQLMesh: it keeps the physical tables under
    mangled names and exposes fact_sales as a view in its virtual layer, so
    looking only at tables finds nothing even after a successful plan.

    A writer still holding the file, or a model that does not exist yet, is a
    "not yet" rather than a failure.
    """
    try:
        con = duckdb.connect(WAREHOUSE, read_only=True)
    except Exception:
        return None
    try:
        found = con.execute(
            "select table_schema from information_schema.tables "
            "where table_name = 'fact_sales'"
        ).fetchall()
        if not found:
            return None
        counts = {}
        for (schema,) in found:
            try:
                counts[schema] = con.execute(
                    f'select count(*) from "{schema}".fact_sales'
                ).fetchone()[0]
            except Exception:
                continue
        if not counts:
            return None
        if len(counts) > 1:
            print(f"    found fact_sales in {counts}", flush=True)
        return max(counts.values())
    except Exception:
        return None
    finally:
        con.close()


want = expected_rows()
print(f"source feeds hold {want:,} transactions between them", flush=True)

seen = None
deadline = time.time() + TIMEOUT
while time.time() < deadline:
    seen = fact_rows()
    print(f"  fact_sales: {seen if seen is not None else 'not built yet'}", flush=True)
    if seen == want:
        print(f"fact_sales holds {seen:,} rows, one per source transaction")
        sys.exit(0)
    time.sleep(10)

print(f"::error::fact_sales holds {seen} rows after {TIMEOUT}s, expected {want}")
sys.exit(1)
