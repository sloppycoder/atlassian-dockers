#!/bin/bash

set -o errexit

# build all the images

(
    cd java-base
    docker build --rm --tag sloppycoder/java-base .
)

(
    cd atl-postgres
    docker build --rm --tag sloppycoder/atl-postgres .
)

for MODULE in $(ls -d atl-*)
do
(
    echo building $MODULE
    cd $MODULE
    TAG="sloppycoder/$MODULE"

    docker build --rm --tag ${TAG}:latest .

    case "$MODULE" in

        atl-jira|atl-stash)

            ENV_STRING="$(docker inspect  -f '{{ index .ContainerConfig.Env 5 }}' ${TAG}:latest )" 
            VERSION="$(echo $ENV_STRING | cut -d '=' -f 2 )"

            if [ ! -z "$VERSION" ]; then
                docker tag -f ${TAG}:latest ${TAG}:${VERSION}
            fi
        ;;

        *)

        ;;
     esac
)
done
