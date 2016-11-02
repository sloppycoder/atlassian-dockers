#! /bin/bash

DOCKER_REGISTRY_PREFIX=sloppycoder

[ "$DATA_DIR" = "" ] && DATA_DIR=/data

POSTGRES_DATA=$DATA_DIR/postgres
ATL_DATA=$DATA_DIR/atlassian-home

[ ! -d "$ATL_DATA" ] && echo "Unable to find data volume $ATL_DATA" && exit 1
[ ! -d "$POSTGRES_DATA" ] && echo "Unable to find data volume $POSTGRES_DATA" && exit 1


is_container_running() {

    if [ "$(docker inspect -f '{{ .State.Running }}' $1 2> /dev/null)" = "true" ]; then
        return 0
    else
        return 1
    fi
}


stop_and_rm_container() {

    is_container_running $1 && docker stop $1
    ( docker ps -a | grep -q $1 ) && docker rm $1
}


start_app() {

    [ "$2" = "-i" ] && RUN_MODE="-it" ||  RUN_MODE="-d"

    stop_and_rm_container $1

    echo starting $1
    docker run $RUN_MODE --name $1 --link postgres:db \
        --volume=$ATL_DATA:/opt/atlassian-home -e BASE_URL=$BASE_URL \
        ${DOCKER_REGISTRY_PREFIX}/atl-$1 $3
}


start_db() {

    stop_and_rm_container postgres

    docker run -d --name postgres -e POSTGRES_PASSWORD=password \
        --volume=$POSTGRES_DATA:/var/lib/postgresql/data ${DOCKER_REGISTRY_PREFIX}/atl-postgres
}


start_web() {

    BASE_DIR=`dirname $0`
    $($BASE_DIR/parse_base_url.py $BASE_URL)

    if [ -z "$BASE_URL_SCHEME" ]; then
        BASE_URL_SCHEME="http"
        BASE_URL_PORT="80"
    fi
    
    if [ "$BASE_URL_SCHEME" = "http" ]; then
        PORTS="-p $BASE_URL_PORT:80"
    else
        PORTS="-p $BASE_URL_PORT:443"
    fi

    is_container_running jira && LINKS="$LINKS --link jira:jira"
    is_container_running stash && LINKS="$LINKS --link stash:stash"
    is_container_running bamboo && LINKS="$LINKS --link bamboo:bamboo"

    echo starting httpd with links $LINKS
    stop_and_rm_container httpd
    docker run -d --name httpd \
       $PORTS \
       $LINKS \
       ${DOCKER_REGISTRY_PREFIX}/atl-web

    [ -z "$LINKS" ] && echo httpd started but no application running.
}


    
ACTION=$1

# when this script is piped into /bin/bash as describe in README.md
# it'll boot up all components
if [ ! -t 0 ]; then

    ACTION=all 
    
    echo
    echo starting all docker containers for Atlassian Jira, Stash, Fisheye and Bamboo
    echo all images will be downloaded from docker hub for the first time, this will take a while.
    echo 
    echo hit ctrl-C to abort ...
    echo
    sleep 2

fi


    
case "$ACTION" in

    all)
        start_db
        start_app jira
        start_app stash
        start_app bamboo
        sleep 2 && start_web

    ;;

    jira|stash|bamboo)
        
        stop_and_rm_container $1
        start_app $1 $2 $3 $4
        # start web browser if container not launched run.sh <app> -i <cmd>
        [ -z "$2" ] && start_web

    ;;

    web)
        
        start_web        

    ;;

    db)
        
        start_db        

    ;;

    dbsh)

        docker exec -it postgres /bin/bash

    ;;

    kill)
        stop_and_rm_container httpd
        stop_and_rm_container bamboo
        stop_and_rm_container jira
        stop_and_rm_container stash
        stop_and_rm_container postgres

    ;;

    clean)

        docker rmi $(docker images | grep "^<none>" | awk ' {print $3} ')

    ;;

    *)

        echo "

 Usage:

    run.sh all             # start everything

    run.sh <app>           # stop and remove <app> container, create a new one in background
                           # then restart web server 
                           # <app> can be jira, stash or bamboo

    run.sh <app> -i <cmd>  # start <app> container in interactive mode, pass <cmd> to docker

    run.sh  web            # restart web server 

    run.sh  db             # stop and remove db container, then start a new one

    run.sh  dbsh           # launch a shell into db server

    run.sh  kill           # stop and remove everything

    run.sh  clean          # remoev all untagged images
"
    ;;

esac 


