#!/bin/bash
set -o errexit
umask 0022

JIRA_HOME=/opt/atlassian-home/jira

mkdir -p $JIRA_HOME

rm -f $JIRA_HOME/.jira-home.lock

if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  CONTEXT_PATH="/$CONTEXT_PATH"
fi

xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" /opt/jira/conf/server-backup.xml > /opt/jira/conf/server.xml

exec "$@"