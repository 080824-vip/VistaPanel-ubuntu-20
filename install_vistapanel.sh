#!/bin/bash

# Thêm kho lưu trữ của Ondřej Surý
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y

# Cập nhật hệ thống và cài đặt các gói cần thiết
sudo apt update && sudo apt install -y     php8.1     php8.1-mysql     php8.1-common     php8.1-xml     php8.1-cli     php8.1-fpm     php8.1-curl     php8.1-gd     php8.1-mbstring     php8.1-zip     php8.1-bcmath     php8.1-imap     php8.1-intl     php8.1-soap     php8.1-xmlrpc     php8.1-xsl     php8.1-ldap     php8.1-redis     php8.1-memcached     php8.1-sqlite3     php8.1-odbc     php8.1-pgsql     php8.1-sybase     php8.1-tidy     php8.1-xmlreader     php8.1-xmlwriter     php8.1-xdebug     php8.1-bz2     php8.1-dba     php8.1-enchant     php8.1-gmp     php8.1-imagick     php8.1-interbase     php8.1-mcrypt     php8.1-pspell     php8.1-snmp

# Cấu hình allow_url_fopen
if [ -f /etc/php/8.1/cli/php.ini ]; then
    sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.1/cli/php.ini
fi

if [ -f /etc/php/8.1/fpm/php.ini ]; then
    sudo sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.1/fpm/php.ini
fi

# Khởi động lại PHP-FPM
if systemctl list-units --full -all | grep -Fq 'php8.1-fpm.service'; then
    sudo systemctl restart php8.1-fpm
fi

echo "Cài đặt hoàn tất!"
