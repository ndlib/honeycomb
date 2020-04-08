# Honeycomb - Collection and Item administration

[![Build Status](https://travis-ci.org/ndlib/honeycomb.svg?branch=master)](https://travis-ci.org/ndlib/honeycomb)
[![Coverage Status](https://img.shields.io/coveralls/ndlib/honeycomb.svg)](https://coveralls.io/r/ndlib/honeycomb?branch=master)
[![Code Climate](https://codeclimate.com/github/ndlib/honeycomb/badges/gpa.svg)](https://codeclimate.com/github/ndlib/honeycomb)

Honeycomb provides basic collection and item administration, as well as serialization of your collections so they can be used by external applications.

## Dependencies
Requires ruby v2.1.9, postgres 9.5.4+, solr 6.3.0

## Installation Notes
Honeycomb depends on other services for handling things like images, audio/video, and authentication. Some of these are configured in settings.yml, and others in secrets.yml. Ensure that the following keys are populated for your environment:
### config/settings.yml
```
<rails environment>
  background_processing: <true|false to enqueue jobs to rabbitmq>
  export_batch_size: <number of rows to batch when writing to google>
  image_server_url: <honeypot url (https)>
  beehive_url: <beehive url (https)>
  media_server_url: <buzz url (https)>
  aws:
    region: <aws region>
    bucket: <bucket to put media files in>
    profile: <profile name to read from the ~/.aws/credentials>
```
### config/secrets.yml
```
<rails environment>
  secret_key_base: <secret key base>
  sneakers: &sneakers_local
    amqp: <amqp url>
    vhost: <vhost on the rabbit mq server>
  google:
    client_id: <The client id in "APIs & Auth/Credentials/OAuth 2.0 client IDs">
    client_secret: <The secret key in "APIs & Auth/Credentials/OAuth 2.0 client IDs">
    developer_key: <The API key in "APIs & Auth/Credentials/API keys">
    app_id: <app id>  <The project number shown in the overview of the application>
  okta:
    client_id:
    client_secret:
    redirect_url:
    base_auth_url:
    logout_url:
    auth_server_id:
```
### config/database.yml
```
<rails environment>
  adapter: postgresql
  encoding: utf8
  reconnect: true
  pool: 5
  username: <db user>
  password: <db pass>
  host:     <db host>
  database: <db name>
```

### ~/.aws/credentials
When uploading audio and video files, honeycomb will put the files in an S3 bucket. The credentials that are used to do this for the defined bucket must be defined in the ~/.aws/credentials file:
```
[profile name from settings.yml]
aws_access_key_id = <user key id>
aws_secret_access_key = <user secret>
```
See http://docs.aws.amazon.com/sdkforruby/api/#Configuration for more info.

### solr
Start solr and point it's home to your cloned copy's solr directory. See config/solr.yml for ports and core names that honeycomb will expect to use within each environment. Here's an example of how to start in development:
```
solr start -p 8982 -Dsolr.solr.home=/path/to/honeycomb/solr
```

### start application

```
SSL=true bundle exec rails s
```
