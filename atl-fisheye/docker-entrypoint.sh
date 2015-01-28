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

    if [ ! -d  "$FISHEYE_INST" ]; then
        mkdir -p $FISHEYE_INST
    fi

    chown -R fisheye:fisheye $FISHEYE_INST

    if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
        CONTEXT_PATH=
    else
       CONTEXT_PATH="/$CONTEXT_PATH"
    fi

    FISHEYE_CONFIG=$FISHEYE_INST/config.xml

    if [ ! -f "$FISHEYE_CONFIG" ]; then

        if [ ! -z "$CONTEXT_PATH" ]; then 
            xmlstarlet ed --insert "/config/web-server" --type attr -n context -v "$CONTEXT_PATH" \
                  /opt/fecru-${FISHEYE_VERSION}/config.xml > $FISHEYE_CONFIG
        fi

        if [ ! -z "$BASE_URL" ]; then
            
            parse_base_url $BASE_URL

            mv $FISHEYE_CONFIG config.tmp

            xmlstarlet ed \
                --insert "/config/web-server" --type attr -n site-url -v "${BASE_URL}${CONTEXT_PATH}" \
                --insert "/config/web-server/http" --type attr -n proxy-scheme -v "$BASE_URL_SCHEME" \
                --insert "/config/web-server/http" --type attr -n proxy-host -v "$BASE_URL_HOST" \
                --insert "/config/web-server/http" --type attr -n proxy-port -v "$BASE_URL_PORT" \
                config.tmp > $FISHEYE_CONFIG

            rm -f config.tmp
        fi

        chown fisheye:fisheye $FISHEYE_CONFIG
    fi

    /opt/fecru-${FISHEYE_VERSION}/bin/start.sh

    exec tail -f $FISHEYE_INST/var/log/fisheye.out
    
fi


exec "$@"



