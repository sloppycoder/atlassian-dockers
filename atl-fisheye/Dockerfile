FROM sloppycoder/java-base
MAINTAINER Li Lin <guru.lin@gmail..com>

# Install Fisheye
ENV FISHEYE_VERSION 3.9.0
RUN curl -Lks http://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${FISHEYE_VERSION}.zip \
         -o /root/fisheye.zip \
      && unzip -q /root/fisheye.zip -d /opt \
      && rm /root/fisheye.zip

RUN /usr/sbin/groupadd atlassian \
      && /usr/sbin/useradd -M --home-dir /opt/fisheye --groups atlassian --shell /bin/bash fisheye \
      && chown -R fisheye:fisheye /opt/fecru-${FISHEYE_VERSION}

ADD ./docker-entrypoint.sh /
ADD ./parse_base_url.py /
VOLUME ["/opt/atlassian-home"]

ENV FISHEYE_INST /opt/atlassian-home/fisheye
ENV CONTEXT_PATH fisheye

EXPOSE 8060

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]

