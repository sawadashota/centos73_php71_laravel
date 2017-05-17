# Master image
FROM centos:7
MAINTAINER sawada@stanfoot.com

# Base package
RUN yum -y update
RUN yum -y install sudo
RUN yum -y install libxml2 libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel gcc make
RUN yum install -y git zip unzip openssl-devel curl-devel vim-enhanced wget

WORKDIR /root

# Install PHP7.1
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y --enablerepo=remi-php71 install php php-fpm php-intl php-mbstring php-xml php-pdo php-mysqlnd php-opcache php-mcrypt php-gd php-devel

# Install Redis
RUN yum --enablerepo=epel install -y redis

# Install MySQL5.7
RUN rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
RUN yum install -y mysql-community-server

# Install Laravel newest version
RUN curl -s http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require "laravel/installer"

# Set date JST
RUN cp /etc/localtime /etc/localtime.org
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Make httpd conf
COPY vhost.conf /etc/httpd/conf.d/

# Auth start systemctl
RUN systemctl enable httpd.service
RUN systemctl enable redis

# alias
RUN echo 'alias artisan="php artisan"' >> ~/.bashrc
RUN echo 'alias g="git"' >> ~/.bashrc
RUN echo 'alias ls="ls -la"' >> ~/.bashrc
RUN echo 'alias rm="rm -r"' >> ~/.bashrc
RUN echo 'alias sb="source ~/.bashrc"' >> ~/.bashrc
RUN echo 'alias app="cd /var/www/html/app"' >> ~/.bashrc

# php-timecop
WORKDIR /root/dl
RUN git clone https://github.com/hnw/php-timecop.git
WORKDIR /root/dl/php-timecop
RUN phpize
RUN ./configure
RUN make
RUN make install
COPY php.ini /etc/php.ini
RUN rm -rf /root/dl
WORKDIR /root

# vim config
COPY .vimrc /root/

WORKDIR /var/www/html/app
EXPOSE 80
