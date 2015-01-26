FROM sloppycoder/java-base
MAINTAINER Li Lin <guru.lin@gmail..com>

# Download and extract Stash 
ENV STASH_VERSION 3.6.0
RUN curl -Lks http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-${STASH_VERSION}.tar.gz \
         -o /root/stash.tar.gz \
      && mkdir /opt/stash \
      && tar zxf /root/stash.tar.gz --strip=1 -C /opt/stash \
      && rm /root/stash.tar.gz \
      && sed -i -e "s/^#!\/bin\/sh/#!\/bin\/bash/" /opt/stash/bin/catalina.sh \
      && mv /opt/stash/conf/server.xml /opt/stash/conf/server-backup.xml

# create group and users to run Stash
RUN /usr/sbin/groupadd atlassian \
      && /usr/sbin/useradd --create-home --home-dir /opt/stash --groups atlassian --shell /bin/bash stash \
      && chown -R stash:stash /opt/stash

ADD ./docker-entrypoint.sh /

# Launching Stash
ENV CONTEXT_PATH stash
USER stash
EXPOSE 7990 7999
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/stash/bin/start-stash.sh", "-fg"]
