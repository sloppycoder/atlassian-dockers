# Docker container for Atlassian JIRA, Stash, Fisheye and Bamboo

Based on work by [repository by atlassianlabs](https://bitbucket.org/atlassianlabs/atlassian-docker) and upgrade software version and use Centos7 and Oracle JDK8.


### TL;DR
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

To run the images without build,

curl -s https://github.com/sloppycoder/atlassian-dockers/blob/master/run_all.sh | /bin/bash -


### TO DO:

* Setup bamboo....5.7.2
* improvement: add check existing DB logic into dbinit script and incorporate into run_all.sh
* fin dout best way to support adding base url 
* Stash auto site_url config works. but needs logic to prevent adding attributes multiple times
   not an issue for fisheye because it skips configuration once the config file is present
