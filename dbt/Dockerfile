FROM python:3.11-slim

RUN apt-get update && apt-get install -y git make automake gcc g++ subversion && rm -rf /var/lib/apt/lists/*

RUN git clone -n --depth=1 --filter=tree:0 https://github.com/cnstlungu/postcard-company-datamart.git /datamart

WORKDIR /datamart

RUN git sparse-checkout set --no-cone postcard_company

CMD ["git", "checkout"]