FROM centos:7
MAINTAINER Li Lin <guru.lin@gmail.com>

# this is a data only container used to manage files created
# by various Atlassian software, ie. JIRA, Stash, Bamboo, Fisheye

VOLUME ["/opt/atlassian-home"]
VOLUME ["/var/lib/postgresql/data"]

CMD ["bin/bash"]
