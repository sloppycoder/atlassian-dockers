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

# initialize database
sleep 5
cat dbinit.sh | docker run --rm -i --link postgres:db postgres:9.3 bash -

# start application containers and link it to volume from data container 
docker run -d --name jira --link postgres:db \
       --volumes-from="atldata" \
       sloppycoder/atl-jira
sleep 3

docker run -d --name stash --link postgres:db \
       --volumes-from="atldata" -e BASE_URL=$BASE_URL \
       sloppycoder/atl-stash
sleep 3

docker run -d --name fisheye --link postgres:db \
       --volumes-from="atldata" -e BASE_URL=$BASE_URL \
       sloppycoder/atl-fisheye
sleep 3
       
# start web server that proxies all request to applications
docker run -d --name atlweb --link stash:stash -p 80:80 -p 443:443 \
       --link stash:stash --link jira:jira --link fisheye:fisheye \
       -v $PWD/httpd24-conf:/usr/local/apache2/conf \
       httpd:2.4
       
