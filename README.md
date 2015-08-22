# Docker containers for Atlassian JIRA, Stash, Fisheye and Bamboo

These containers are intended to run behind BASE_URL served Apache httpd.


### TL;DR

One liner to get everything up and running,

```
# if using boot2docker, replace 127.0.0.1 with the IP of the boot2docker VM
export BASE_URL=http://127.0.0.1

curl -sL https://raw.githubusercontent.com/sloppycoder/atlassian-dockers/master/run.sh | bash -
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
|  Fisheye (optional, not started by default)      | BASE_URL/fisheye    |

To use the postgres database, use __db__ as host name, postgres as username and password as passord. Database name is same as application name, e.g jira, stash, bamboo, fisheye.

### Known issues
1. Seems to have issue with Docker 1.8.1 with boot2docker image in OS X Yosemite. Though things work fine in Docker 1.6.2 on Amazon linux.

### Test with boot2docker, Amazon EC2 instance and Google Compute Enginge

#### boot2docker with Parallels on Mac

The following steps should work for most people. 

```
cd vagrant/paralles
vagrant up

# copy the certificates files from ~/.docker in the VM to the host machine
# modify docker-env script and update the DOCKER_CERT_PATH with directory above
# then

. ./docker-env

```


#### Amazon EC2 instance with Amazon Linux AMI (HVM)
Before ```vagrant up``` please check the Vagrantfile to make sure it contains the configuration you want, especially the your access key, region, VPC subnet_id etc in order to work correctly. 

#### Google Compute Engine with image "centos-7-v20150127"
Before ```vagrant up``` please check the Vagrantfile to make sure it contains the configuration you want, especially the your aproject id, access client email and key location. For ssh access to the instance, please upload your ssh key via console before spin up the instance. 

see [GCE documentation](https://cloud.google.com/compute/docs/console#sshkeys) for details. more references in [this GitHub issue](https://github.com/mitchellh/vagrant-google/issues/23)
 
