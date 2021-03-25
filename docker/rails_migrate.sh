#!/bin/bash

### Wait for dependencies
if ! docker/wait-for-it.sh -t 120 ${DB_HOSTNAME}:5432; then exit 1; fi

echo Running container in "$PWD" with the following command: "$@"
exec "$@"