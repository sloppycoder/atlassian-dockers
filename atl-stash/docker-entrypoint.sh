#!/bin/bash

set -o errexit
umask 0027

parse_base_url() {

    BASE_DIR=`dirname $0`
    $($BASE_DIR/parse_base_url.py $1)

}

SERVER_CONFIG=/opt/stash/conf/server.xml

if [ "$1" = "start" ]; then

    if [ ! -d "$STASH_HOME" ]; then
        mkdir -p $STASH_HOME
    fi

    chown -R stash:stash $STASH_HOME

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

    chown stash:stash  $SERVER_CONFIG
    
    exec /usr/local/bin/gosu stash /opt/stash/bin/start-stash.sh -fg

fi


exec "$@"
