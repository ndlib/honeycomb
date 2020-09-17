#! /bin/bash
# Doing the tasks that are needed to use persistent EFS in Fargate

echo "WOOP WOOP"

if [ -d "/mnt/solr" ]
then
    cp -R /opt/solr/server/solr/ /mnt/solr
    ls /mnt/solr/solr/
else
    ls /mnt/solr/
fi