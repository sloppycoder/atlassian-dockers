FROM httpd:2.4
MAINTAINER Li Lin <guru.lin@gmail..com>

RUN mv /usr/local/apache2/conf/httpd.conf httpd.conf.orig
ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD proxy-atl.conf /usr/local/apache2/conf/extra/proxy-atl.conf

