#!/bin/bash

# 
# can we replace hardcoded password, host and port number 
# and use env variables instead? 
#
echo <<EOF
echo "
CREATE DATABASE jira WITH ENCODING='UTF8' TEMPLATE=template0;
CREATE DATABASE stash WITH ENCODING='UTF8' TEMPLATE=template0; 
CREATE DATABASE fisheye WITH ENCODING='UTF8' TEMPLATE=template0;  " \
  | PGPASSWORD="password" psql -h db -p 5432 -d postgres -U postgres -w

EOF | docker run --rm -i --link postgres:db postgres:9.3 bash -
