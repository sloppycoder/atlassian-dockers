#!/bin/bash

set -o errexit

TAG=sloppycoder/atl-bamboo

docker build --rm --tag ${TAG}:latest .

VERSION_STRING=`docker inspect  -f '{{ index .ContainerConfig.Env 2 }}' sloppycoder/atl-jira`
VERSION=`echo $VERSION_STRING | awk ' { match($0, ".*=(.*)", a) } END { print a[1] }' `

docker tag ${TAG}:latest ${TAG}/${VERSION}
