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

### Development

_Note: the commands to finish the development environment will create a fresh database from seed data. This is a potentially destructive action with the wrong environment variables. Developers should ensure they are not pointing at a database that they wish to persist._

To finish the development environment, additional commands will need to be run as follows:

```console
docker-compose exec rails bundle exec rake assets:precompile
docker-compose exec rails bundle exec rake db:setup RAILS_ENV=development
open https://localhost:3000
```

* Rails will add the local Docker network to allowed hosts within the application. Without this step, you will be unable to access the webapp.
* Rails will precompile assets for the development environment.
* Rails will seed data into the database via the `db:setup` rake task. The Solr index will be built as the database is seeded. Currently, two collections will be built: `Pretty Animals` and `Places and Monuments`. The other collections in the seed repository error as of 2020-08-05.
* The webapp will start over SSL - once done, you can access the webapp at `https://localhost:3000`.

### Running Unit Tests

As a developer is working on application changes, you may wish to run unit tests prior to commiting code. The commands under [development](#development) do not need to be run in order to run the unit test suite. The container first needs to be restarted after modifying the docker-compose.yml and changed the RAILS_ENV to "test". To run unit tests within the built Docker environment, the following commands can be run:

```console
docker-compose exec rails bundle exec rake --trace db:migrate test RAILS_ENV=test
```

The environment will now be prepared for running unit tests, which can be done as follows:

```console
docker-compose exec rails bundle exec rspec spec
```

The output of the unit tests will be visible in the terminal window. If you would like to output the `rspec` output to a file, it could be done with a command similar to the following:

```console
docker-compose exec rails bundle exec rspec spec > ~/rspec_honeycomb_ruby2_4.txt
```

## Terminating the Environment

To terminate the container environment, press Control-C (on a Mac/Linux machine) in the Terminal window where you originally ran your `docker-compose up --build` command.

There are additional commands to reclaim local space that could be run on the local machine. These should be run at the developers' own risk. Instructions can be found [here](http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html).
