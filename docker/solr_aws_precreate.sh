#! /bin/bash
# Doing the tasks that are needed to use persistent EFS in Fargate

if [ -d "/mnt/solr" ]
then
    cp -R /opt/solr/server/solr/ /mnt/solr
fi

# TODO: 
# This allows ecs to start the new container, but this leaves the potential
# for corruption if both the new and old container write to the index. This 
# can happen, for example, if a long running index task is running while ECS 
# starts draining connections during a deployment event.
# I'm just putting this here to get things going in development, but this will
# probably need to be handled by some pipeline that deploys with some
# downtime. Theoretically, it should:
#   1. Stop the container, waits for it to stop
#   2. Remove the lock, if it exists. It should not exists, unless solr was 
#      unable to gracefully stop
#   3. Starts the new container
# Note there is downtime between step 1 and 3, and extended downtime if 3 fails
# Only other option is to look into solr cloud or some other configuration that's
# better equipped to handle 0 downtime and horizontal scaling.
if [ -f "/mnt/solr/solr/honeycomb/data/index/write.lock" ]; then
    rm /mnt/solr/solr/honeycomb/data/index/write.lock
fi
