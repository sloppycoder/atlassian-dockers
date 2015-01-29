DB_USER=$postgres

create_db_if_not_exist() {

    ( psql -l -U $DB_USER | grep $1 ) || \
        echo " CREATE DATABASE $1 WITH ENCODING='UTF8' TEMPLATE=template0; " | psql -U $DB_USER 
}

create_db_if_not_exist jira
create_db_if_not_exist stash
create_db_if_not_exist fisheye
create_db_if_not_exist bamboo


