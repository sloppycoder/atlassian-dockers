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



