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

if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  echo "SOURCE_DIR is not set. Quitting."
  exit 1
fi

mkdir -p ~/.aws
touch ~/.aws/credentials

echo ${SOURCE_DIR}

ls -al ${SOURCE_DIR}

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

if [ -d "${SOURCE_DIR}/variables" ]; then
    aws s3 sync ${SOURCE_DIR}/variables s3://${AWS_S3_BUCKET}/variables --exact-timestamps --delete --region ${AWS_REGION} $*
fi

if [ -d "${SOURCE_DIR}/requirements" ]; then
    aws s3 sync ${SOURCE_DIR}/requirements s3://${AWS_S3_BUCKET}/requirements --exact-timestamps --delete --region ${AWS_REGION} $*
fi

if [ -d "${SOURCE_DIR}/dags" ]; then
    aws s3 sync ${SOURCE_DIR}/dags s3://${AWS_S3_BUCKET}/dags --exact-timestamps --delete --region ${AWS_REGION} $*
fi

if [ -d "${SOURCE_DIR}/plugins" ]; then
    aws s3 sync ${SOURCE_DIR}/plugins s3://${AWS_S3_BUCKET}/plugins --exact-timestamps --delete --region ${AWS_REGION} $*
fi

rm -rf ~/.aws