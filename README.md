# Docker containers for Atlassian JIRA, Stash and Jenkins

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
mkdir -p $DATA_DIR/atlassain-home
mkdir -p $DATA_DIR/jenkins_home

sh run.sh 

```


To build the images locally, clone this repo first, then  

``` 
./build.sh 

``` 

Then point your browser at the URL below to  install license and configuation for each applicaiton:

| Application                                      |  URL                |
|--------------------------------------------------|---------------------|
|  JIRA    										   | BASE_URL/jira       |
|  Stash    			   						   | BASE_URL/stash      |
|  Jenkins    									   | BASE_URL/jenkins    |




