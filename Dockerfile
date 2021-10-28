#FROM python:3.6
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:alex-p/tesseract-ocr
RUN apt-get update && apt-get install -y tesseract-ocr-all

RUN apt-get update
RUN apt-get install -y jq zip python3 python3-pip
RUN python3 -m pip install --upgrade pip
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
