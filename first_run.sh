#! /bin/bash

# 
# script to start up all containers for the first time
#

# change the path to reflect your configuration 

if [ -z "$VOL_PATH" ]; then
  VOL_PATH=/mnt/sda1/data
  mkdir -p $VOL_PATH
fi

# volume for Postgres database files
if [ -z "$PGDATA_PATH" ]; then
  PGDATA_PATH=$VOL_PATH/pgdata
  mkdir -p $PGDATA_PATH
fi

# volume for Atlassian applications
if [ -z "$ATLDATA_PATH" ]; then
  ATLDATA_PATH=$VOL_PATH/atl
  mkdir -p $ATLDATA_PATH
fi

# start the data only container 
docker run --name atldata \
           -v $ATLDATA_PATH:/opt/atlassian-home \
           -v $PGDATA_PATH:/var/lib/postgresql/data \
           sloppycoder/atl-data

# start database server
docker run -d --name postgres -e POSTGRES_PASSWORD=password \
       --volumes-from="atldata" postgres:9.3

# initialize database
sleep 5
cat dbinit.sh | docker run --rm -i --link postgres:db postgres:9.3 bash -



# start Jira container and link it to volume from data container
docker run -d --name jira --link postgres:db -p 8080:8080  \
       --volumes-from="atldata" sloppycoder/atl-jira

# start Stash container and link it to volume from data container
docker run -d --name stash --link postgres:db -p 7990:7990 -p 7999:7999 \
       --volumes-from="atldata" sloppycoder/atl-stash

# start Fisheye container and link it to volume from data container
docker run -d --name fisheye --link postgres:db -p 8060:8060 \
       --volumes-from="atldata" sloppycoder/atl-fisheye
       
