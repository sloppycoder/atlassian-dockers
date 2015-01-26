#!/bin/bash
set -o errexit
umask 0027

if [ "$1" = "start" ]; then

    if [ ! -d "$JIRA_HOME" ]; then
        mkdir -p $JIRA_HOME
    fi

    chown -R jira:jira $JIRA_HOME
    rm -f $JIRA_HOME/.jira-home.lock

    if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
        CONTEXT_PATH=
    else
        CONTEXT_PATH="/$CONTEXT_PATH"
    fi

    xmlstarlet ed -u "//Context/@path" -v "$CONTEXT_PATH" /opt/jira/conf/server-backup.xml > /opt/jira/conf/server.xml
    chown jira:jira  /opt/jira/conf/server.xml
    
    exec /usr/local/bin/gosu jira /opt/jira/bin/start-jira.sh -fg

fi


exec "$@"
