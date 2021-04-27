#!/bin/bash

# All the things that will execute when starting the rails service
ln -s /mnt/honeycomb /project_root/public/system/images

### Wait for dependencies
if ! docker/wait-for-it.sh -t 120 ${DB_HOSTNAME}:5432; then exit 1; fi
if ! docker/wait-for-it.sh -t 120 ${SOLR_HOST}:8983; then exit 1; fi

echo Running container in "$PWD" with the following command: "$@"
exec "$@"