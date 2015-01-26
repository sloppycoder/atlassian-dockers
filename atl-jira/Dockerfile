FROM sloppycoder/java-base
MAINTAINER Li Lin <guru.lin@gmail.com>

# Download and extract Jira
ENV JIRA_VERSION 6.3.14
RUN curl -Lks http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${JIRA_VERSION}.tar.gz \
         -o /root/jira.tar.gz \
      && mkdir /opt/jira \
      && tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira \
      && rm /root/jira.tar.gz \
      && mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml \
      && echo "jira.home = /opt/atlassian-home/jira" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties 

# create group and users to run Jira
RUN /usr/sbin/groupadd atlassian \
      && /usr/sbin/useradd --create-home --home-dir /opt/jira --groups atlassian --shell /bin/bash jira \
      && chown -R jira:jira /opt/jira 

ADD ./docker-entrypoint.sh /

ENV CONTEXT_PATH jira
USER jira
EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/jira/bin/start-jira.sh", "-fg"]
