FROM python:3.11

RUN apt-get install git make automake gcc g++ subversion

RUN git clone -n --depth=1 --filter=tree:0 https://github.com/cnstlungu/postcard-company-datamart.git /generator

WORKDIR /generator

RUN git sparse-checkout set --no-cone generator && git checkout

WORKDIR /generator/generator

RUN pip install uv

RUN uv pip install --system -r requirements.txt

CMD ["python3", "generate.py"]