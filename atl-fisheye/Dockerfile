FROM sloppycoder/java-base
MAINTAINER Li Lin <guru.lin@gmail..com>

# Install Fisheye
ENV FISHEYE_VERSION 3.6.3
RUN curl -Lks http://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${FISHEYE_VERSION}.zip \
         -o /root/fisheye.zip \
      && unzip -q /root/fisheye.zip -d /opt \
      && rm /root/fisheye.zip

RUN /usr/sbin/groupadd atlassian \
      && /usr/sbin/useradd --create-home --home-dir /opt/fisheye --groups atlassian --shell /bin/bash fisheye \
      && chown -R fisheye:fisheye /opt/fecru-${FISHEYE_VERSION}

ADD ./docker-entrypoint.sh /
VOLUME ["/opt/atlassian-home"]

ENV FISHEYE_OPTS "-Djava.net.preferIPv4Stack=true"
EXPOSE 8060
USER fisheye
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tail", "-f", "/opt/atlassian-home/fisheye/var/log/fisheye.out"]

