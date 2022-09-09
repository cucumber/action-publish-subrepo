FROM python:3.10-alpine

USER root

WORKDIR /app

RUN apk add git \
    openssh \
    github-cli \
    curl \
    bash

RUN pip3 install git-filter-repo

ADD entrypoint.sh ./
ADD publish-to-subrepo ./

RUN chmod 777 "./entrypoint.sh"

ENTRYPOINT ["/app/entrypoint.sh"]
