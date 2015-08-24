#
#  Centos7 base image for running Java apps
#

FROM centos:7
MAINTAINER Li Lin <guru.lin@gmail.com>

# add EPEL repo
# how do I get official link to EPEL instead of the mirror site?
RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm 

# install a few things that we'll need
# and install gosu
# see https://docs.docker.com/articles/dockerfile_best-practices
RUN yum update -y  \
      && yum install -y   \
               bzip2      \
               java-1.8.0-openjdk-headless \
               jq         \
               net-tools  \
               p7zip      \
               tar        \
               telnet     \
               unzip      \
               xml2       \
               xmlstarlet \
               zip        \
      && yum clean all \
      && curl -o /usr/local/bin/gosu -Lks https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64 \
      && curl -o /usr/local/bin/gosu.asc -sL https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc \
      && gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
      && gpg --verify /usr/local/bin/gosu.asc \
      && rm /usr/local/bin/gosu.asc \
      && chmod +x /usr/local/bin/gosu

CMD ["/bin/bash", "--login"]

