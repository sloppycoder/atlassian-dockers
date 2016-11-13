#!/bin/bash

[ "$BASE_URL" == "" ] && echo "BASE_URL not set, abort." && exit 1

[ "$DATA_DIR" = "" ] && DATA_DIR=/data

POSTGRES_DATA=$DATA_DIR/postgres
ATL_DATA=$DATA_DIR/atlassian-home
JENKINS_HOME=$DATA_DIR/jenkins-home

[ -d "$POSTGRES_DATA" ] || mkdir -p $POSTGRES_DATA
[ -d "$ATL_DATA" ]      || mkdir -p $ATL_DATA
[ -d "$JENKINS_HOME" ]  || mkdir -p $JENKINS_HOME

[ -d "$POSTGRES_DATA" ] && \
[ -d "$ATL_DATA" ]      && \
[ -d "$JENKINS_HOME" ]  && \
    docker-compose -d




