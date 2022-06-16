#!/bin/bash
# Step 1 - download all:
wget https://github.com/codesshaman/cryptopro/archive/refs/heads/main.zip
unzip main.zip
# Step 2 - install CryptoPRO CSP:
cd cryptopro-main/linux-amd64_deb/
chmod +x install.sh
./install.sh
# result:
# CryptoPro CSP packages have been successfully installed
# Step 3 - install license:
dpkg -i lsb-cprocsp-devel_5.0.12500-6_all.deb
# Step 4: install linux cades for cryptopro:
cd ../cades_linux-amd64
# dpkg -i cprocsp-pki-plugin-64_2.0.14589-1_amd64.deb
dpkg -i cprocsp-pki-phpcades-64_2.0.14589-1_amd64.deb
dpkg -i cprocsp-pki-cades-64_2.0.14589-1_amd64.deb
# result:
# License 0A202-U0030-00ECW-RRLMF-UU2WK is set
# [ErrorCode: 0x00000000]
# License TA200-G0030-00ECW-RRLNE-BTDVV is set
# [ReturnCode: 0x00000000]
# Step 6: unpack php sources:
cd ../php7_sources
cp php-7.2.24.tar.gz /opt
cd /opt
tar -xvzf php-7.2.24.tar.gz
mv php-7.2.24 php
rm php-7.2.24.tar.gz
# Step 7 configure php:
cd php
./configure --prefix=/opt/php --enable-fpm
# Step 8: Change path to php configuration:
rm /opt/cprocsp/src/phpcades/Makefile.unix
cp /tmp/cryptopro-main/Makefile.unix /opt/cprocsp/src/phpcades/
# Step 9: use g++ v6 like default compiller:
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 5
# Step 10: patch php:
cp /tmp/cryptopro-main/php7_support.patch/php7_support.patch /opt/cprocsp/src/phpcades
cd /opt/cprocsp/src/phpcades
ln -s /opt/cprocsp/src/phpcades/libphpcades.so /usr/lib/php/20170718/libphpcades.so
ln -s /opt/cprocsp/src/phpcades/phpcades.so /usr/lib/php/20170718/phpcades.so
patch -p0 < ./php7_support.patch
# Step 11: make php sources:
# ln -s /opt/cprocsp/src/phpcades/libphpcades.so /usr/lib/php/20170718/libphpcades.so
eval `/opt/cprocsp/src/doxygen/CSP/../setenv.sh --64`; make -f Makefile.unix
php -i | grep extension_dir
# Step 12: add extension to php ini file:
echo "extension=phpcades.so" >> /etc/php/7.2/cli/php.ini


php --re php_CPCSP