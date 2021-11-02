FROM python:3.6

RUN apt-get update
RUN apt-get install -y jq zip python3 python3-pip
RUN python3 -m pip install --upgrade pip
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
