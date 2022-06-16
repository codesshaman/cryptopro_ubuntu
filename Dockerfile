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
    make g++ patch g++-6 php-dev

WORKDIR /tmp

COPY ./sources .

RUN cd /tmp/linux-amd64_deb && chmod +x install.sh && ./install.sh && \
    dpkg -i lsb-cprocsp-devel_5.0.12500-6_all.deb && cd /tmp/cades_linux-amd64 && \
    dpkg -i cprocsp-pki-phpcades-64_2.0.14589-1_amd64.deb && \
    dpkg -i cprocsp-pki-cades-64_2.0.14589-1_amd64.deb && \
    cp /tmp/php7_sources/php-7.2.24.tar.gz /opt && cd /opt && \
    tar -xvzf php-7.2.24.tar.gz && mv php-7.2.24 php && \
    rm /opt/php-7.2.24.tar.gz && cd /opt/php/ && ./configure --prefix=/opt/php --enable-fpm && \
    rm /opt/cprocsp/src/phpcades/Makefile.unix && \
    cp /tmp/Makefile.unix /opt/cprocsp/src/phpcades/ && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10 && \
    cp /tmp/php7_support.patch/php7_support.patch /opt/cprocsp/src/phpcades && \
    ln -s /opt/cprocsp/src/phpcades/libphpcades.so /usr/lib/php/20170718/libphpcades.so && \
    ln -s /opt/cprocsp/src/phpcades/phpcades.so /usr/lib/php/20170718/phpcades.so

RUN cd /opt/cprocsp/src/phpcades $$ patch -p0 < ./php7_support.patch

# CMD ["bash", "config.sh"]