#!/bin/bash
PROJECT=csthr
BUCKET=${PROJECT}.library.nd.edu
ENV_ALIAS=honeycombpprd-vm

cd ./public/cache_data

curl -o cst_data.json https://${ENV_ALIAS}.library.nd.edu/v1/collections/vatican/items
curl -o ihrl_data.json https://${ENV_ALIAS}library.nd.edu/v1/collections/humanrights/items

aws s3 mb s3://${BUCKET}
aws s3 website s3://${BUCKET} --index-document index.html --error-document index.html
aws s3 sync . s3://${BUCKET} --exclude '.*' --exclude '*.md' --delete --acl public-read

echo ${BUCKET}.s3-website-us-east-1.amazonaws.com
