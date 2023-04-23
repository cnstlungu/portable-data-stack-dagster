
FROM python:3.9-slim

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD

WORKDIR /home/generator

COPY generator .

RUN pip install -r requirements.txt

CMD ["python", "generate.py"]