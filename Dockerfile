FROM jenkins/jenkins:2.263.1
USER root
RUN apk update && apk --no-cache add --update bash sudo nano sudo zip bzip2 fontconfig wget curl 'su-exec>=0.2'

RUN apk add docker
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose


RUN addgroup jenkins docker

