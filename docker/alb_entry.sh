# All the things that will execute when starting the rails service

### Wait for dependencies
if ! /wait-for-it.sh -t 120 nginx:80; then exit 1; fi

nginx-debug -g "daemon off;"