FROM python:3.11-slim

# Pin the shared dbt model / generator to a tagged release of
# https://github.com/cnstlungu/postcard-company-datamart
# Override with: docker compose build --build-arg DATAMART_REF=main
ARG DATAMART_REF=v1.2.0

RUN apt-get update && apt-get install -y git make automake gcc g++ subversion && rm -rf /var/lib/apt/lists/*

RUN git clone -n --branch "${DATAMART_REF}" --depth=1 --filter=tree:0 https://github.com/cnstlungu/postcard-company-datamart.git /datamart

WORKDIR /datamart

RUN git sparse-checkout set --no-cone postcard_company

CMD ["git", "checkout"]