FROM ubuntu:18.04

ENV TZ=Europe/Moscow

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER root

RUN apt update && \
    apt install -y wget \
    libboost-dev sqlite3 \
    curl mc autoconf tar \
    libxml2-dev nano gcc \
    libsqlite3-dev sqlite3 \
    make g++ patch g++-6 php-dev fastjar

WORKDIR /tmp

# COPY ./scripts .

# CMD ["bash", "config.sh"]