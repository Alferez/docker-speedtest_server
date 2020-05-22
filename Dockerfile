FROM debian:10
MAINTAINER Jose A Alferez <correo@alferez.es>


ENV DEBIAN_FRONTEND noninteractive

#### Configure TimeZone
RUN echo "Europe/Madrid" > /etc/timezone && dpkg-reconfigure tzdata

#### Instalamos dependencias, Repositorios y Paquetes
RUN apt-get update -y --fix-missing && apt-get -y upgrade && apt-get install -y --fix-missing wget curl nano apache2 libapache2-mod-php php-cli php certbot python-certbot-apache

#### Configuramos Apache
RUN a2enmod cgi && a2enmod rewrite && echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf && ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf

RUN mkdir /speedtest
WORKDIR /speedtest
RUN wget http://install.speedtest.net/ooklaserver/ooklaserver.sh && chmod +x /speedtest/ooklaserver.sh && /speedtest/ooklaserver.sh install -f

EXPOSE 80
EXPOSE 8080
EXPOSE 5060

RUN apt-get install -y --fix-missing zip unzip

WORKDIR /var/www/html
RUN wget http://install.speedtest.net/httplegacy/http_legacy_fallback.zip
RUN unzip http_legacy_fallback.zip
RUN mv /var/www/html/speedtest/* /var/www/html/
RUN rm -rf /var/www/html/speedtest
RUN rm http_legacy_fallback.zip
COPY ./assets/crossdomain.xml /var/www/html/crossdomain.xml
COPY ./assets/OoklaServer.properties /speedtest/OoklaServer.properties

### Limpiamos
RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/*
RUN rm -rf /var/lib/apt/lists/*

### Add Entrypoing
ADD ./assets/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /root

ENTRYPOINT "/start.sh"

