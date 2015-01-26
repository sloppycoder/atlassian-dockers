#
#  Centos7 base image for running Java apps
#

FROM centos:7
MAINTAINER Li Lin <guru.lin@gmail.com>

# install a few things that we'll need
# and install gosu
# see https://docs.docker.com/articles/dockerfile_best-practices
RUN yum update -y  \
      && yum install -y   \
               bzip2      \
               net-tools  \
               postgresql-server  \
               tar        \
               unzip      \
               xmlstarlet \
               zip  
      && yum clean all \
      && curl -o /usr/local/bin/gosu -Lks https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64 \
      && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
      && gpg --verify /usr/local/bin/gosu.asc \
      && rm /usr/local/bin/gosu.asc \
      && chmod +x /usr/local/bin/gosu


