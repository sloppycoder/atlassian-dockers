#!/bin/bash
set -o errexit
umask 0027

if [ "$1" = "start" ]; then

    if [ ! -d "$JIRA_HOME" ]; then
        mkdir -p $JIRA_HOME
    fi

    chown -R jira:jira $JIRA_HOME
    rm -f $JIRA_HOME/.jira-home.lock

    if [ ! -f "/opt/jira/conf/server.xml.1" ]; then 
         # do this only when it's first launch
        if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
            CONTEXT_PATH=
        else
            CONTEXT_PATH="/$CONTEXT_PATH"
            xmlstarlet ed -u "//Context/@path" -v "$CONTEXT_PATH" /opt/jira/conf/server.xml.orig > /opt/jira/conf/server.xml
        fi

        cp /opt/jira/conf/server.xml /opt/jira/conf/server.xml.1

        chown jira:jira  /opt/jira/conf/server.xml*
    fi
    
    exec /usr/local/bin/gosu jira /opt/jira/bin/start-jira.sh -fg

fi


exec "$@"
