
FROM python:3.9-slim

RUN apt-get update && apt-get install -y libpq-dev gcc wget

RUN pip install uv

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD

WORKDIR /home/generator

COPY generator .

RUN uv pip install --system --no-cache -r requirements.txt

CMD ["python", "generate.py"]
