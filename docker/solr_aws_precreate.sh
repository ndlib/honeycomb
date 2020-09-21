#! /bin/bash
# Doing the tasks that are needed to use persistent EFS in Fargate

if [ -d "/mnt/solr" ]
then
    cp -R /opt/solr/server/solr/ /mnt/solr
fi