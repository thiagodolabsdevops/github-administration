#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 -c CLOUD_PROVIDER -p PROJECT_ID -b BUCKET_NAME [-d DYNAMODB_TABLE_NAME] [-l BUCKET_REGION]"
  echo "  -c CLOUD_PROVIDER       Cloud provider (gcp or aws)"
  echo "  -p PROJECT_ID           Google Cloud Project ID or AWS Profile Name"
  echo "  -b BUCKET_NAME          Name of the bucket to create"
  echo "  -d DYNAMODB_TABLE_NAME  (Optional) Name of the DynamoDB table to create - for AWS only (default: terraform-state-lock)"
  echo "  -l BUCKET_REGION        (Optional) Region for the bucket (default: us-central1 for GCP, us-east-1 for AWS)"
  exit 1
}

# Default bucket regions
GCP_BUCKET_REGION="us-central1"
AWS_BUCKET_REGION="us-east-1"
DYNAMODB_TABLE_NAME="terraform-state-lock"

# Parse command-line options
while getopts ":c:p:b:d:l:" opt; do
  case ${opt} in
    c )
      CLOUD_PROVIDER=$OPTARG
      ;;
    p )
      PROJECT_ID=$OPTARG
      ;;
    b )
      BUCKET_NAME=$OPTARG
      ;;
    d )
      DYNAMODB_TABLE_NAME=$OPTARG
      ;;
    l )
      BUCKET_REGION=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done

# Check if required options are provided
if [ -z "$CLOUD_PROVIDER" ] || [ -z "$PROJECT_ID" ] || [ -z "$BUCKET_NAME" ]; then
  usage
fi

# Set default region if not provided
if [ -z "$BUCKET_REGION" ]; then
  if [ "$CLOUD_PROVIDER" == "gcp" ]; then
    BUCKET_REGION=$GCP_BUCKET_REGION
  elif [ "$CLOUD_PROVIDER" == "aws" ]; then
    BUCKET_REGION=$AWS_BUCKET_REGION
  else
    usage
  fi
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to create a GCP bucket
create_gcp_bucket() {
  # Check if gcloud CLI is installed
  if ! command_exists gcloud; then
    echo "Error: gcloud CLI is not installed."
    exit 1
  fi

  # Authenticate with GCP (if not already authenticated)
  # gcloud auth application-default login

  # Set the project
  echo "Setting $PROJECT_ID as default Project... "
  gcloud config set project $PROJECT_ID

  # Enable Cloud Storage API
  echo "Enabling storage API..."
  gcloud services enable storage.googleapis.com

  USER_IDENTIFIER=$(gcloud config list account | grep account | cut -d" " -f3)

  # Figuring out account type
  if [[ "$USER_IDENTIFIER" == *"gserviceaccount"* ]]; then
    ACCT_TYPE="serviceAccount"
  else
    ACCT_TYPE="user"
  fi

  # Grant roles to the account
  echo "Granting required permissions..."
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="${ACCT_TYPE}:${USER_IDENTIFIER}" --role="roles/storage.admin"

  # Create the bucket
  gcloud storage buckets create gs://$BUCKET_NAME --location=$BUCKET_REGION --public-access-prevention

  # Confirm bucket creation
  if [ $? -eq 0 ]; then
    echo "GCP bucket $BUCKET_NAME created successfully in project $PROJECT_ID, region $BUCKET_REGION."
  else
    echo "Failed to create GCP bucket $BUCKET_NAME."
  fi
}

# Function to create an AWS bucket and DynamoDB table
create_aws_bucket() {
  # Check if aws CLI is installed
  if ! command_exists aws; then
    echo "Error: aws CLI is not installed."
    exit 1
  fi

  # Authenticate with AWS (if not already authenticated)
  # aws configure --profile $PROJECT_ID

  # Create S3 Bucket
  echo "Creating S3 bucket: $BUCKET_NAME in region $BUCKET_REGION..."
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$BUCKET_REGION"

  # Enable versioning on the S3 bucket
  echo "Enabling versioning for bucket: $BUCKET_NAME..."
  aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled

  if [ -n "$DYNAMODB_TABLE_NAME" ]; then
    # Create DynamoDB Table
    echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME in region $BUCKET_REGION..."
    aws dynamodb create-table \
        --table-name "$DYNAMODB_TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region "$BUCKET_REGION"

    # Wait until the DynamoDB table is created
    echo "Waiting for DynamoDB table: $DYNAMODB_TABLE_NAME to be created..."
    aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE_NAME"
  fi

  # Confirm bucket and table creation
  if [ $? -eq 0 ]; then
    echo "AWS bucket $BUCKET_NAME created successfully in profile $PROJECT_ID and region $BUCKET_REGION."
    if [ -n "$DYNAMODB_TABLE_NAME" ]; then
      echo "DynamoDB table $DYNAMODB_TABLE_NAME created successfully."
    fi
  else
    echo "Failed to create AWS bucket $BUCKET_NAME or DynamoDB table $DYNAMODB_TABLE_NAME."
  fi
}

# Create the bucket based on the cloud provider
case $CLOUD_PROVIDER in
  gcp)
    create_gcp_bucket
    ;;
  aws)
    create_aws_bucket
    ;;
  *)
    usage
    ;;
esac
