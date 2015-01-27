#! /bin/bash

# start the data only container 
docker run --name atldata \
           -v /opt/atlassian-home \
           -v /var/lib/postgresql/data \
           centos:7 /bin/bash

# start database server
docker run -d --name postgres -e POSTGRES_PASSWORD=password \
       --volumes-from="atldata" postgres:9.3
sleep 3

# to do add db create here

# start Jira container and link it to volume from data container
docker run -d --name jira --link postgres:db \
       --volumes-from="atldata" -e BASE_URL=$BASE_URL \
       sloppycoder/atl-jira
sleep 3

# start Stash container and link it to volume from data container
docker run -d --name stash --link postgres:db \
       --volumes-from="atldata" -e BASE_URL=$BASE_URL \
       sloppycoder/atl-stash
sleep 3

# start Fisheye container and link it to volume from data container
docker run -d --name fisheye --link postgres:db \
       --volumes-from="atldata" -e BASE_URL=$BASE_URL \
       sloppycoder/atl-fisheye
sleep 3
       
# start front end apache server
docker run -d --name atlweb --link jira:jira,stash:stash,fisheye:fisheye \
       sloppycoder/atl-web
       
