#!/bin/bash

set -o errexit

# build all the images

(
    cd java-base
    docker build --rm --tag sloppycoder/java-base .
)

for MODULE in $(ls -d atl-*)
do
(
    echo building $MODULE
    cd $MODULE
    TAG="sloppycoder/$MODULE"

    docker build --rm --tag ${TAG}:latest .

    case "$MODULE" in

        atl-jira|atl-stash|atl-bamboo|atl-fisheye)

            ENV_STRING="$(docker inspect  -f '{{ index .ContainerConfig.Env 2 }}' ${TAG}:latest )" 
            VERSION="$(echo $ENV_STRING | awk ' { match($0, ".*=(.*)", a) } END { print a[1] }')"

            [ -z "$VERSION" ] || docker tag ${TAG}:latest ${TAG}:${VERSION}
        ;;

        *)

        ;;
     esac
)
done
