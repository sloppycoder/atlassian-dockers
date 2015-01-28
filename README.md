# Docker containers for Atlassian JIRA, Stash, Fisheye and Bamboo

These containers are intended to run behind one BASE_URL served Apache httpd.


### TL;DR

Clone this repo first, then  use ``` ./build_all.sh ``` to build all images. To skip build and run everything directly from docker hub,


```
BASE_URL=http://127.0.0.1:8000 ./run.sh all

```

The point your browser and start apply license and configuration to applications.

JIRA:    BASE_URL/jira
Stash:   BASE_URL/stash
Fisheye: BASE_URL/fisheye
Bamboo:  BASE_URL/bamboo


### TO DO:

* Setup bamboo....5.7.2
* improvement: add check existing DB logic into dbinit script and incorporate into run_all.sh
* docker rmi $(docker images | grep "^<none>" | awk "{print $3}")