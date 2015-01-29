#! /bin/bash

DOCKER_HUB_USER=sloppycoder

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

    run.sh  db             # stop and remove db container, then start a new one

    run.sh  dbsh           # launch a shell into db server

    run.sh  datash         # start an interactive container for examine the shared data volumes

    run.sh  backup <dir>   # backup all data inside data container into <dir>/atldata.tar.gz

    run.sh  clean          # remoev all untagged images

"

}


is_container_running() {

    if [ "$(docker inspect -f '{{ .State.Running }}' $1 2> /dev/null)" = "true" ]; then
        return 1
    else
        return 0
    fi
}


stop_and_rm_container() {

    is_container_running $1 || docker stop $1
    ( docker ps -a | grep -q $1 ) && docker rm $1
}


start_app() {

    [ "$2" = "-i" ] && RUN_MODE="-it" ||  RUN_MODE="-d"

    stop_and_rm_container $1

    start_data

    docker run $RUN_MODE --name $1 --link postgres:db \
        --volumes-from="atldata" -e BASE_URL=$BASE_URL \
        ${DOCKER_HUB_USER}/atl-$1 $3
}


start_db() {

    stop_and_rm_container postgres

    start_data

    docker run -d --name postgres -e POSTGRES_PASSWORD=password \
        --volumes-from="atldata" ${DOCKER_HUB_USER}/atl-postgres
}


start_data() {
    (docker ps -a | grep -q atldata ) || \
        docker run --name atldata \
            -v /opt/atlassian-home \
            -v /var/lib/postgresql/data \
            centos:7 echo atldata container
}


start_web() {

    is_container_running jira && LINKS="$LINKS --link jira:jira"
    is_container_running stash && LINKS="$LINKS --link stash:stash"
    is_container_running fisheye && LINKS="$LINKS --link fisheye:fisheye"
    is_container_running bamboo && LINKS="$LINKS --link bamboo:bamboo"

    echo starting httpd with links $LINKS
    stop_and_rm_container atlweb
    docker run -d --name atlweb -p 80:80 -p 443:443 \
       $LINKS \
       ${DOCKER_HUB_USER}/atl-web

    [ -z "$LINKS" ] && echo httpd started but no application running.
}


    
ACTION=$1
[ -z "$ACTION" ] && ACTION=all
    
case "$ACTION" in

    all)
        echo
        echo use 
        echo      run.sh -h
        echo 
        echo to see other options available in this command
        echo 
        echo
        echo starting all docker containers for Atlassian Jira, Stash, Fisheye and Bamboo
        echo all images will be downloaded from docker hub for the first time, this will take a while.
        echo 
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
        
        stop_and_rm_container $1
        start_app $1 $2 $3 $4
        [ -z "$2" ] && start_web

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

    dbsh)

        docker exec -it postgres /bin/bash

    ;;

    datash)

        docker run -it --rm --volumes-from="atldata" centos:7 /bin/bash

    ;;

    backup)

        BACKUP_DIR=$(readlink -f $2)
        echo backing up all data in atldata to $BACKUP_DIR

        docker run -it --rm --volumes-from atldata -v $BACKUP_DIR:/backup  ${DOCKER_HUB_USER}/java-base  \
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


