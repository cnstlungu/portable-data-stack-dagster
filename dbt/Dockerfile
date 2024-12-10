FROM python:3.11

RUN apt-get install git make automake gcc g++ subversion

RUN git clone -n --depth=1 --filter=tree:0 https://github.com/cnstlungu/postcard-company-datamart.git /datamart

WORKDIR /datamart

RUN git sparse-checkout set --no-cone postcard_company

CMD ["git", "checkout"]