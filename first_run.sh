#! /bin/bash

# 
# script to start up all containers for the first time
#

# start the data only container 
docker run --name atldata \
           -v /opt/atlassian-home \
           -v /var/lib/postgresql/data \
           centos:7 /bin/bash

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
       
