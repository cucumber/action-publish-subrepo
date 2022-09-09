FROM alpine

USER root

WORKDIR /app

RUN apk add git \
    openssh \
    git-subtree \
    git-lfs \
    github-cli \
    curl \
    bash

ADD entrypoint.sh ./
ADD publish-to-subrepo ./

RUN chmod 777 "./entrypoint.sh"

ENTRYPOINT ["/app/entrypoint.sh"]
