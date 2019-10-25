#!/bin/sh

set -e

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_DEFAULT_REGION" ]; then
  echo "AWS_DEFAULT_REGION is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  echo "SOURCE_DIR is not set. Quitting."
  exit 1
fi

mkdir -p ~/.aws
touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials
 
aws s3 sync ${SOURCE_DIR}/variables s3://${AWS_S3_BUCKET}/variables --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
aws s3 sync ${SOURCE_DIR}/requirements s3://${AWS_S3_BUCKET}/requirements --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
aws s3 sync ${SOURCE_DIR}/dags s3://${AWS_S3_BUCKET}/dags --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
aws s3 sync ${SOURCE_DIR}/plugins s3://${AWS_S3_BUCKET}/plugins --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
aws s3 sync ${SOURCE_DIR}/sql s3://${AWS_S3_BUCKET}/sql --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
aws s3 sync ${SOURCE_DIR}/turner_lib s3://${AWS_S3_BUCKET}/turner_lib --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*

rm -rf ~/.aws
