#!/bin/bash

set -o errexit
umask 0022

if [ -z "$STASH_HOME" ]; then
  export STASH_HOME=/opt/atlassian-home/stash
  mkdir -p $STASH_HOME
fi
echo "STASH_HOME set to $STASH_HOME"

if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  echo "Setting context path to: $CONTEXT_PATH"
  CONTEXT_PATH="/$CONTEXT_PATH"
fi

xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" /opt/stash/conf/server-backup.xml > /opt/stash/conf/server.xml

exec "$@"