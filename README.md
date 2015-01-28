# Docker containers for Atlassian JIRA, Stash, Fisheye and Bamboo

These containers are intended to run behind one BASE_URL served Apache httpd.


### TL;DR

To run the images without build,

```
BASE_URL=http://host:port curl -s https://github.com/sloppycoder/atlassian-dockers/blob/master/run_all.sh | /bin/bash -
```

The easiest way to build all images, then start all containers and make all application available at BASE_URL (defaults )

```
./build_all.sh
BASE_URL=http://127.0.0.1:8000 ./run_all.sh

```

The point your browser and start apply license and configuration to applications.

JIRA:    BASE_URL/jira
Stash:   BASE_URL/stash
Fisheye: BASE_URL/fisheye
Bamboo:   BASE_URL/bamboo


### TO DO:

* Setup bamboo....5.7.2
* improvement: add check existing DB logic into dbinit script and incorporate into run_all.sh
