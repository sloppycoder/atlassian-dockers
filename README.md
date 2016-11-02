# Docker containers for Atlassian JIRA, Stash and Bamboo

These containers are intended to run behind BASE_URL served Apache httpd.


### TL;DR

One liner to get everything up and running,

```
#
# on a machine that has docker installed
#

# this the URL where application can be accessed from
export BASE_URL=http://127.0.0.1

# create data directory to store application state
export DATA_DIR=/data # or your own directory name
mkdir -p $DATA_DIR/postgres
mkdir -p $DATA_DIR/atl_home

sh run.sh all

```


To build the images locally, clone this repo first, then  

``` 
./build.sh 

# if using boot2docker, replace 127.0.0.1 with the IP of the boot2docker VM
BASE_URL=http://127.0.0.1 ./run.sh all

``` 

Then point your browser at the URL below to  install license and configuation for each applicaiton:

| Application                                      |  URL                |
|--------------------------------------------------|---------------------|
|  JIRA    										   | BASE_URL/jira       |
|  Stash    			   						   | BASE_URL/stash      |
|  Bamboo    									   | BASE_URL/bamboo     |

To use the postgres database, use __db__ as host name, postgres as username and password as passord. Database name is same as application name, e.g jira, stash, bamboo, fisheye.



