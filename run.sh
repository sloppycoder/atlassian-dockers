#! /bin/bash

usage() {

echo "

 Usage:

    run.sh                 # startup everything
    run.sh all             # 

    run.sh <app>           # stop and remove <app> container, create a new one in background
                           # then restart web server 
                           # <app> can be jira, stash, fisheye or bamboo

    run.sh <app> -i <cmd>  # start <app> container in interactive mode, pass <cmd> to docker

    run.sh  web            # restart web server 

    run.sh  db             # start db server

    run.sh  dbshell        # launch a shell into db server

    run.sh  initdb         # drop and recreate database used by applications

    run.sh  data           # start an interactive container for examine the shared data volumes

    run.sh  backup <dir>   # backup all data inside data container into <dir>/atldata.tar.gz

    run.sh  clean          # remoev all untagged images

"

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

    echo starting httpd with links $LINKS
    docker run -d --name atlweb -p 80:80 -p 443:443 \
       $LINKS \
       sloppycoder/atl-web

    test -z "$LINKS" && echo httpd started but no application running.
}

    
ACTION=$1
test -z "$ACTION" && ACTION=all
    
case "$ACTION" in

    all)
        echo
        echo
        echo starting all docker containers for Atlassian Jira, Stash, Fisheye and Bamboo
        echo all images will be downloaded from docker hub for the first time, this will take a while
        echo hit ctrl-C to abort ...
        echo
        sleep 2

        start_data
        start_db
        sleep 2
        start_app jira
        sleep 2
        start_app stash
        sleep 2
        start_app fisheye
        sleep 2
        start_app bamboo
        sleep 2
        start_web

    ;;

    jira|stash|fisheye|bamboo)
        docker stop $1
        docker rm $1
        start_app $1 $2 $3 $4
        if [ -z "$2" ]; then
            start_web
        fi
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

    dbshell)
        docker exec -it postgres /bin/bash
    ;;

    data)
        docker run -it --rm --volumes-from="atldata" centos:7 /bin/bash
    ;;

    backup)
        BACKUP_DIR=$(readlink -f $2)
        docker run -it --rm --volumes-from atldata -v $BACKUP_DIR:/backup  sloppycoder/java-base  \
              tar czvf /backup/atldata.tar.gz \
                   /opt/atlassian-home /var/lib/postgresql/data 
    ;;

    clean)
        docker rmi $(docker images | grep "^<none>" | awk ' {print $3} ')
    ;;

    *)
        usage
    ;;

esac 


