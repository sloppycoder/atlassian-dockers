# Docker containers for Atlassian JIRA, Stash, Fisheye and Bamboo

These containers are intended to run behind one BASE_URL served Apache httpd.


### TL;DR

One liner to get everything up and running

```
export BASE_URL=http://127.0.0.1:8000 
curl -sL https://raw.githubusercontent.com/sloppycoder/atlassian-dockers/master/run.sh | bash -
```


To build the images locally, clone this repo first, then  

``` 
./build.sh 
BASE_URL=http://127.0.0.1:8000 ./run.sh 

``` 

Then point your browser at the URL below to  install license and configuation for each applicaiton:

| JIRA      | BASE_URL/jira     |
| Stash     | BASE_URL/stash    |
| Fisheye   | BASE_URL/fisheye  |
| Bamboo    | BASE_URL/bamboo   |


### TO DO
1. test more installation scenarios.
