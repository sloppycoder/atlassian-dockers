echo "
CREATE DATABASE jira WITH ENCODING='UTF8' TEMPLATE=template0;
CREATE DATABASE stash WITH ENCODING='UTF8' TEMPLATE=template0; 
CREATE DATABASE fisheye WITH ENCODING='UTF8' TEMPLATE=template0;  " \
  | PGPASSWORD="password" psql -h db -p 5432 -d postgres -U postgres -w

