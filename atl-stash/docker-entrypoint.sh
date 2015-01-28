#!/bin/bash

set -o errexit
umask 0027

parse_base_url() {

    BASE_URL_SCHEME=`echo $1 |  awk ' { match($0,"(.*)://([0-9a-zA-Z\.]*):?([0-9]*)?",a) }  END { print a[1] }' `  
    BASE_URL_HOST=`echo $1   |  awk ' { match($0,"(.*)://([0-9a-zA-Z\.]*):?([0-9]*)?",a) }  END { print a[2] }' `  
    BASE_URL_PORT=`echo $1   |  awk ' { match($0,"(.*)://([0-9a-zA-Z\.]*):?([0-9]*)?",a) }  END { print a[3] }' `  

    if [ -z "$BASE_URL_PORT" ]; then
        BASE_URL_PORT=80
    fi

    echo === parse_base_url debug ===
    echo BASE_URL=$1
    echo BASE_URL_SCHEME=$BASE_URL_SCHEME
    echo BASE_URL_HOST=$BASE_URL_HOST
    echo BASE_URL_PORT=$BASE_URL_PORT

}

SERVER_CONFIG= /opt/stash/conf/server.xml

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

        mv $SERVER_CONFIG config.tmp

        COUNT=`xmlstarlet sel -t -v "count(/Server/Service/Connector/@scheme)"  $SERVER_CONFIG`

        if [ "$COUNT" = "0"]; then
            xmlstarlet ed --insert "/Server/Service/Connector" --type attr -n scheme -v "$BASE_URL_SCHEME" \
                          --insert "/Server/Service/Connector" --type attr -n proxyName -v "$BASE_URL_HOST"  \
                          --insert "/Server/Service/Connector" --type attr -n proxyPort -v "$BASE_URL_PORT"  \
                  config.tmp > $SERVER_CONFIG
        else 
            xmlstarlet ed --upadte "/Server/Service/Connector/@scheme" -v "$BASE_URL_SCHEME" \
                          --update "/Server/Service/Connector/@proxyName" -v "$BASE_URL_HOST"  \
                          --update "/Server/Service/Connector/@proxyPort" -v "$BASE_URL_PORT"  \
                  config.tmp > $SERVER_CONFIG
        fi
        
        rm -f config.tmp
    fi

    chown stash:stash  $SERVER_CONFIG
    
    exec /usr/local/bin/gosu stash /opt/stash/bin/start-stash.sh -fg

fi


exec "$@"
