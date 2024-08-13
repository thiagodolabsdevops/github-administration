#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 -c CLOUD_PROVIDER -b BUCKET_NAME"
  echo "  -c CLOUD_PROVIDER    Cloud provider (aws or gcp)"
  echo "  -b BUCKET_NAME       Name of the bucket to use"
  exit 1
}

# Parse command-line options
while getopts ":c:b:" opt; do
  case ${opt} in
    c )
      CLOUD_PROVIDER=$OPTARG
      ;;
    b )
      BUCKET_NAME=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done

# Check if required options are provided
if [ -z "$CLOUD_PROVIDER" ] || [ -z "$BUCKET_NAME" ]; then
  usage
fi

# Validate the cloud provider input
if [[ "$CLOUD_PROVIDER" != "aws" && "$CLOUD_PROVIDER" != "gcp" ]]; then
  echo "Invalid cloud provider. Please choose 'aws' or 'gcp'."
  exit 1
fi

# File paths
BACKEND_FILE="backend.tf"

# Check if backend.tf exists
if [ ! -f "$BACKEND_FILE" ]; then
  echo "Error: backend.tf file not found!"
  exit 1
fi

# Function to comment out a backend block
comment_backend() {
  sed -i.bak -e "/backend \"$1\" {/,/}/ s/^/  #/" "$BACKEND_FILE"
}

# Function to uncomment a backend block and update the bucket name
uncomment_backend_and_update_bucket() {
  echo ${BUCKET_NAME}
  sed -i.bak -e "/#\s*backend \"$1\" {/,/#}/ s/^  #//" "$BACKEND_FILE"
  sed -i.bak -e "/backend \"$1\" {/,/}/ s/\(bucket\s*=\s*\).*/\1\"${BUCKET_NAME}\"/" "$BACKEND_FILE"
}

# Modify the backend.tf file based on the selected cloud provider
if [ "$CLOUD_PROVIDER" == "aws" ]; then
  uncomment_backend_and_update_bucket "s3"
  comment_backend "gcs"
elif [ "$CLOUD_PROVIDER" == "gcp" ]; then
  uncomment_backend_and_update_bucket "gcs"
  comment_backend "s3"
fi

# Remove the backup file created by sed
rm -f "${BACKEND_FILE}.bak"

terraform fmt
echo "Updated backend configuration for $CLOUD_PROVIDER with bucket $BUCKET_NAME in $BACKEND_FILE"
