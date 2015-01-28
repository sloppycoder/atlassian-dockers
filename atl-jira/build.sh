#!/bin/bash

set -o errexit

TAG="sloppycoder/atl-jira"

docker build --rm --tag ${TAG}:latest .

VERSION_STRING=`docker inspect  -f '{{ index .ContainerConfig.Env 2 }}' ${TAG}:latest `
VERSION=`echo $VERSION_STRING | awk ' { match($0, ".*=(.*)", a) } END { print a[1] }' `

if [ ! -z "$VERSION" ]; then
    echo tagging $VERSION
    docker tag ${TAG}:latest ${TAG}:${VERSION}
fi 
