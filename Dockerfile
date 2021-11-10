FROM python:3.6

RUN apt-get update
RUN apt-get install -y jq zip python3 python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev python3-lxml
RUN python3 -m pip install --upgrade pip
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
