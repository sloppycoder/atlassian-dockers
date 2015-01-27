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

if [ "$1" = "start" ]; then

    if [ ! -d "$STASH_HOME" ]; then
        mkdir -p $STASH_HOME
    fi

    chown -R stash:stash $STASH_HOME

    if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
        CONTEXT_PATH=
    else
        CONTEXT_PATH="/$CONTEXT_PATH"
        xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" \
              /opt/stash/conf/server.xml.orig > /opt/stash/conf/server.xml
    fi

    if [ ! -z "$BASE_URL" ]; then
        
        parse_base_url $BASE_URL

        mv /opt/stash/conf/server.xml /opt/stash/conf/server.xml.tmp

        # the typo Server1 below is to purposely disable this logic
        # somehow this causes Stash not able to work via apache server
        # will fix later
        xmlstarlet ed --insert "/Server/Service/Connector" --type attr -n scheme -v "$BASE_URL_SCHEME" \
                      --insert "/Server/Service/Connector" --type attr -n proxyName -v "$BASE_URL_HOST"  \
                      --insert "/Server/Service/Connector" --type attr -n proxyPort -v "$BASE_URL_PORT"  \
              /opt/stash/conf/server.xml.tmp > /opt/stash/conf/server.xml
        
        rm -f /opt/stash/conf/server.xml.tmp
    fi

    chown stash:stash  /opt/stash/conf/server.xml
    
    exec /usr/local/bin/gosu stash /opt/stash/bin/start-stash.sh -fg

fi


exec "$@"
