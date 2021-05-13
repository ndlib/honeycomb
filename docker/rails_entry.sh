#!/bin/bash
# All the things that will execute when starting the rails service
set -e

# In a mutable host scenario, Capistrano would handle symlinking ./public/system to a persistent
# directory on the host. We'll have to recreate this pattern by providing a mount target (/mnt/system) 
# that we'll mount a persistent volume to later and symlink ./public/system to that mount point. 
# Note: We can create the mount point as part of the build, but we'll have to symlink it in 
# rails_entry.sh since Docker does not allow symlinking outside of the context
ln -s /mnt/system /project_root/public/

### Wait for dependencies
if ! docker/wait-for-it.sh -t 120 ${DB_HOSTNAME}:5432; then exit 1; fi
if ! docker/wait-for-it.sh -t 120 ${SOLR_HOST}:8983; then exit 1; fi

echo Running container in "$PWD" with the following command: "$@"
exec "$@"