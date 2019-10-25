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
 
if [ -d "$SOURCE_DIR/variables" ]; then
    echo "Copying to variables folder"
    aws s3 sync ${SOURCE_DIR}/variables s3://${AWS_S3_BUCKET}/variables --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/variables/`" != "" ]; then
      echo "Remove variables folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/variables/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/variables
      echo "Remove variables folder complete"
  fi
fi

if [ -d "$SOURCE_DIR/requirements" ]; then
    echo "Copying to requirements folder"
    aws s3 sync ${SOURCE_DIR}/requirements s3://${AWS_S3_BUCKET}/requirements --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/requirements/`" != "" ]; then
      echo "Remove requirements folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/requirements/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/requirements
      echo "Remove requirements folder completed"      
  fi
fi

if [ -d "$SOURCE_DIR/dags" ]; then
    echo "Copying to dags folder"
    aws s3 sync ${SOURCE_DIR}/dags s3://${AWS_S3_BUCKET}/dags --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/dags/`" != "" ]; then
      echo "Remove dags folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/dags/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/dags
      echo "Remove dags folder completed"      
  fi
fi

if [ -d "$SOURCE_DIR/plugins" ]; then
    echo "Copying to plugins folder"
    aws s3 sync ${SOURCE_DIR}/plugins s3://${AWS_S3_BUCKET}/plugins --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/plugins/`" != "" ]; then
      echo "Remove plugins folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/plugins/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/plugins
      echo "Remove plugins folder completed"      
  fi
fi

if [ -d "$SOURCE_DIR/sql" ]; then
    echo "Copying to sql folder"
    aws s3 sync ${SOURCE_DIR}/sql s3://${AWS_S3_BUCKET}/sql --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/sql/`" != "" ]; then
      echo "Remove sql folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/sql/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/sql
      echo "Remove sql folder completed"      
  fi
fi

if [ -d "$SOURCE_DIR/turner_lib" ]; then
    echo "Copying to turner_lib folder"
    aws s3 sync ${SOURCE_DIR}/turner_lib s3://${AWS_S3_BUCKET}/turner_lib --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*
else
  if [ "`aws s3 ls s3://$AWS_S3_BUCKET/turner_lib/`" != "" ]; then
      echo "Remove turner_lib folder started"
      aws s3 rm s3://${AWS_S3_BUCKET}/turner_lib/ --recursive
      aws s3 rm s3://${AWS_S3_BUCKET}/turner_lib
      echo "Remove turner_lib folder completed"      
  fi
fi

echo "Cleaning up things"

rm -rf ~/.aws
