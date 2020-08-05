# Docker Development Environment

## Environment Setup

Variable Name | Location or Value
--------------|--------------------
DB_NAME | `postgres`
DB_PASSWORD | `p0stgr3s`
DB_USERNAME | `postgres`
BASE_AUTH_URL | `/all/honeycomb/pre_production/secrets/okta/base_auth_url`
OKTA_BASE_URL | `/all/honeycomb/pre_production/secrets/okta/base_auth_url`
OKTA_CLIENT_ID | `/all/honeycomb/prep/secrets/okta/client_id`
OKTA_CLIENT_SECRET | `/all/honeycomb/prep/secrets/okta/client_secret`
OKTA_LOGOUT_URL | `/all/honeycomb/prep/secrets/okta/logout_url`
OKTA_REDIRECT_URL | `https://localhost:3000/users/auth/oktaoauth/callback`
OKTA_AUTH_ID | `/all/okta/okta_auth_server_id`

## Starting the Environment

Once the proper values are in ENV, you can start the development environment by running the following from the root of your Honeycomb directory:

```console
docker-compose up --build
```

On first run, this may take some time: Docker will pull new base containers for Ruby, Postgres, and Solr if they do not already exist on your local machine.

Postrges will likely finish first, as we are using the very base container with no changes.

Solr should finish next, leveraging the schema files located in `solr/` to create the proper schema.

Ruby/Rails will be the last service to start, as it is dependent on the other two services being available.

* Rails will add the local Docker network to allowed hosts within the application. Without this step, you will be unable to access the webapp.
* Rails will precompile assets for the development environment.
* Rails will seed data into the database via the `db:setup` rake task. The Solr index will be built as the database is seeded. Currently, two collections will be built: `Pretty Animals` and `Places and Monuments`. The other collections in the seed repository error as of 2020-08-05.
* The webapp will start over SSL - once done, you can access the webapp at `https://localhost:3000`.

## Terminating the Environment

To terminate the container environment, press Control-C (on a Mac/Linux machine). There are additional commands to reclaim local space that could be run on the local machine. These should be run at the developers' own risk. Instructions can be found [here](http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html).
