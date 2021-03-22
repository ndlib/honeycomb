# Have to do this here to allow using localhost when deployed with ECS awsvpc
# Could not see a way to have nginx config read env
sed -i "s;\${RAILS_HOST};$RAILS_HOST;g" /etc/nginx/conf.d/default.conf
sed -i "s;\${RAILS_RATE_LIMIT};$RAILS_RATE_LIMIT;g" /etc/nginx/conf.d/default.conf
sed -i "s;\${RAILS_BURST_LIMIT};$RAILS_BURST_LIMIT;g" /etc/nginx/conf.d/default.conf

bash /project_root/wait-for-it.sh -t 120 --strict ${RAILS_HOST}:3000
exec nginx -g 'daemon off;'
