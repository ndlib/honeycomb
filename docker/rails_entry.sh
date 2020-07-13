# All the things that will execute when starting the rails service
# Copy the generated lock file back into the project root. This is to sync this change back to the
# application after the container has mounted the sync volume

cp /bundle/Gemfile.lock ./

# Have to do this here to allow using localhost when deployed with ECS awsvpc
# Could not see a way to have this solr.yml read env
# sed -i "s;\${SOLR_URL};$SOLR_URL;g" /project_root/config/solr.yml

### Wait for dependencies
chmod u+x docker/wait-for-it.sh && bash docker/wait-for-it.sh -t 120 ${DB_HOST}:5432
bash docker/wait-for-it.sh -t 120 ${SOLR_HOST}:8983

# In production we'll be using a persistant database, but not a solr instance,
# so reindex everything on start
# bundle exec rake solr:index:all

### Uncomment below for development ###
exec bundle exec rails s -e development -b 0.0.0.0 

### Uncomment out below for production ###
# exec bundle exec rails s -b 0.0.0.0