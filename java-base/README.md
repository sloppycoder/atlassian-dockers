## Java application based on Centos:7

This image is intended to run Java based applications. It is based on Centos:7 and added following components:

* openjdk-jre-8
* [gosu](https://github.com/tianon/gosu)
* jq
* net-tools (netstat etc.)
* tar
* tcpdump 
* zip/unzip/7zip/bzip2
* xmlstarlet

### to use this image

```
docker pull sloppycoder/java-base
```
