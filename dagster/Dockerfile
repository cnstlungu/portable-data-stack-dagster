FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

RUN pip install uv 

COPY dagster/requirements.txt /tmp/requirements.txt

RUN uv pip install --system -r /tmp/requirements.txt

WORKDIR /

COPY dagster/definitions.py /definitions.py
COPY dagster/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h", "0.0.0.0", "-f", "/definitions.py"]