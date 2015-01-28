#! /bin/bash

BASEDIR=$(readlink -f $0 | xargs dirname)

usage() {

echo <<END_OF_HELP

 Usage:
    run.sh all             # startup everything

    run.sh <app>           # stop and remove <app> container, create a new one in background
                           # then restart web server 
                           # <app> can be jira, stash, fisheye or bamboo

    run.sh <app> -i <cmd>  # start <app> container in interactive mode, pass <cmd> to docker

    run.sh  web            # restart web server 

    run.sh  db             # start db server

    run.sh  initdb         # drop and recreate database used by applications

    run.sh  data           # start an interactive container for examine the shared data volumes

    run.sh  clean          # remoev all untagged images


END_OF_HELP

}

start_app() {

    if [ "$2" = "-i" ]; then
        RUN_MODE="-it"
    else 
        RUN_MODE="-d"
    fi

    docker run $RUN_MODE --name $1 --link postgres:db \
        --volumes-from="atldata" -e BASE_URL=$BASE_URL \
        sloppycoder/atl-$1 $3
}

start_db() {

    docker stop postgres
    docker rm postgres
    docker run -d --name postgres -e POSTGRES_PASSWORD=password \
        --volumes-from="atldata" postgres:9.3
}

init_db() {

    cat dbinit.sh | docker run --rm -i --link postgres:db postgres:9.3 bash -
}

start_data() {

    docker run --name atldata \
        -v /opt/atlassian-home \
        -v /var/lib/postgresql/data \
        centos:7 /bin/bash
}

start_web() {

    docker stop atlweb
    docker rm atlweb

    if [ "`docker inspect -f '{{ .State.Running }}' jira`" = "true" ]; then
       LINKS="$LINKS --link jira:jira"
    fi

    if [ "`docker inspect -f '{{ .State.Running }}' fisheye`" = "true" ]; then
       LINKS="$LINKS --link fisheye:fisheye"
    fi

    if [ "`docker inspect -f '{{ .State.Running }}' stash`" = "true" ]; then
       LINKS="$LINKS --link stash:stash"
    fi

    if [ "`docker inspect -f '{{ .State.Running }}' bamboo`" = "true" ]; then
       LINKS="$LINKS --link bamboo:bamboo"
    fi

    if [ ! -z "$LINKS" ]; then 
        echo starting httpd with links $LINKS
        docker run -d --name atlweb -p 80:80 -p 443:443 \
           -v $BASEDIR/httpd24-conf:/usr/local/apache2/conf \
           $LINKS \
           httpd:2.4
    else  
        echo no application running.
    fi
}
    
    
case "$1" in

    all)
        start_data
        start_db
        sleep 3
        start_app sloppycoder/atl-jira
        sleep 3
        start_app sloppycoder/atl-stash
        sleep 3
        start_app sloppycoder/atl-fisheye
        sleep 3
        start_app sloppycoder/atl-bamboo
        sleep 3
        start_web

    ;;

    jira|stash|fisheye|bamboo)
        docker stop $1
        docker rm $1
        start_app $1
        start_web
    ;;

    web)
        start_web        
    ;;

    db)
        start_db        
    ;;

    initdb)
        init_db        
    ;;

    data)
        docker run -it --rm --volumes-from="atldata" centos:7 /bin/bash
    ;;

    clean)
        docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

    *)
        usage
    ;;

esac 
       
