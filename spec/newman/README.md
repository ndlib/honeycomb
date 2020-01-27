# Testing Honeycomb Deployments with Newman

## Variables Needed

Variable Name | Variable Value
------------- | ---------------
HoneycombURL | The URL to test against. *ex*: **honeycomb.example.com**
HoneycombItemID | The Item ID in Honeycomb you wish to test against *ex*: **hf8f3n3F3fg2d**
HoneycombCollectionsID | The Collection ID in Honeycomb you wish to test against *ex*: **jfhdisufh9ww**

## Testing Locally

The easiest way to run these tests is to leverage the official [Newman Docker Image](https://hub.docker.com/r/postman/newman) from Postman Labs.

Follow these steps:

Pull down the Docker container for Newman (** Note: this is only needed prior to the first run on local machine, and only speeds up Step 3**):

 ``` console
docker pull postman/newman
```

Clone the API Repository ( **Note: this is only required if you do not have a copy of the repository on your machine.** ):

 ``` console
git clone git@github.com:ndlib/api.git
```

Run the Newman collection against the desired RabbitMQ server:

 ``` console
docker run -v /full/path/to/honeycomb/spec/newman:/etc/newman -t postman/newman run honeycomb.postman_collection.json --global-var "HoneycombURL=Value" --global-var "HoneycombItemID=value" --global-var "HoneycombCollectionsID=value"
```
