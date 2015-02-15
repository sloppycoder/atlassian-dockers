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

| Application   |  URL                |
|---------------|---------------------|
|  JIRA         | BASE_URL/jira       |
|  Stash        | BASE_URL/stash      |
| Fisheye       | BASE_URL/fisheye    |
| Bamboo        | BASE_URL/bamboo     |


### Test with boot2docker, Amazon EC2 instance and Google Compute Enginge

#### boot2docker with Parallels on Mac

```
cd vagrant/paralles
vagrant up
```
should work for most people. 

#### Amazon EC2 instance with Amazon Linux AMI (HVM)
Before ```vagrant up``` please check the Vagrantfile to make sure it contains the configuration you want, especially the your access key, region, VPC subnet_id etc in order to work correctly. 

#### Google Compute Engine with image "entos-7-v20150127"
Before ```vagrant up``` please check the Vagrantfile to make sure it contains the configuration you want, especially the your aproject id, access client email and key location. For ssh access to the instance, please upload your ssh key via console before spin up the instance. see (GCE documentation)[https://cloud.google.com/compute/docs/console#sshkeys] for details. more references in (this GitHub issue)[https://github.com/mitchellh/vagrant-google/issues/23]
 
