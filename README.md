# Docker container for Atlassian JIRA, Stash, Fisheye and Bamboo

Based on work by [repository by atlassianlabs](https://bitbucket.org/atlassianlabs/atlassian-docker) and upgrade software version and use Centos7 and Oracle JDK8.


### TL;DR
The easiest way to build all images, then start all containers
```
./build_all.sh
VOL_PATH=<your data volume path> ./first_run.sh
```

if VOL_PATH is not set, it'll default /mnt/sda1/data which should work fine if you use boot2docker.

The point your browser and start apply license and configuration to applications.

JIRA:    http://docker_host:8080/jira
Stash:   http://docker_host:7990/stash
Fisheye: http://docker_host:8060/fisheye
Bamboo:   http://docker_host:1234/bamboo

To run the images without build,

VOL_PATH=<your data volume data> curl -s https://github.com/sloppycoder/atlassian-dockers/blob/master/first_run.sh | /bin/bash -
