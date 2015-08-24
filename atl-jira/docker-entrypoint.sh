#!/bin/bash
set -o errexit
umask 0027

parse_base_url() {

    export TEMP_BASE_URL=$1
    $(python - <<END

import os, urlparse

try:
    base_dir = os.environ['TEMP_BASE_URL']
    r = urlparse.urlparse(base_dir)

    if r.scheme in ['http', 'https'] :
        if r.netloc.find(':') != -1 :
            host, port = r.netloc.split(':')
        else :
            host = r.netloc
            if r.scheme == 'http' :
                port = '80'
            else :
                port = '443'

        print 'export BASE_URL_SCHEME=%s' % r.scheme
        print 'export BASE_URL_HOST=%s' % host
        print 'export BASE_URL_PORT=%s' % port

except:
    pass

END
)
}

SERVER_CONFIG=/opt/jira/conf/server.xml

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
    
    xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" ${SERVER_CONFIG}.orig > $SERVER_CONFIG

    if [ ! -z "$BASE_URL" ]; then
        
        parse_base_url $BASE_URL

        COUNT=`xmlstarlet sel -t -v "count(/Server/Service/Connector/@scheme)"  $SERVER_CONFIG`

        mv $SERVER_CONFIG config.tmp

        if [ "$COUNT" = "0" ]; then
            xmlstarlet ed --insert "/Server/Service/Connector" --type attr -n scheme -v "$BASE_URL_SCHEME" \
                          --insert "/Server/Service/Connector" --type attr -n proxyName -v "$BASE_URL_HOST"  \
                          --insert "/Server/Service/Connector" --type attr -n proxyPort -v "$BASE_URL_PORT"  \
                  config.tmp > $SERVER_CONFIG
        else 
            xmlstarlet ed -u "/Server/Service/Connector/@scheme" -v "$BASE_URL_SCHEME" \
                          -u "/Server/Service/Connector/@proxyName" -v "$BASE_URL_HOST"  \
                          -u "/Server/Service/Connector/@proxyPort" -v "$BASE_URL_PORT"  \
                  config.tmp > $SERVER_CONFIG
        fi
        
        rm -f config.tmp
    fi


    chown jira:jira  $SERVER_CONFIG
    
    exec /usr/local/bin/gosu jira /opt/jira/bin/start-jira.sh -fg

fi


exec "$@"
