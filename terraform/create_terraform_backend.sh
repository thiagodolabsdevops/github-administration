#!/bin/bash

# Variables
S3_BUCKET_NAME="labsdevops-terraform-state-bucket"
DYNAMODB_TABLE_NAME="terraform-state-lock"
AWS_REGION="us-east-1"

# Create S3 Bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME in region $AWS_REGION..."
aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION"

# Enable versioning on the S3 bucket
echo "Enabling versioning for bucket: $S3_BUCKET_NAME..."
aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled

# Create DynamoDB Table
echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME in region $AWS_REGION..."
aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region "$AWS_REGION"

# Wait until the DynamoDB table is created
echo "Waiting for DynamoDB table: $DYNAMODB_TABLE_NAME to be created..."
aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE_NAME"

# Output the results
echo "S3 bucket and DynamoDB table created successfully!"
echo "S3 Bucket: $S3_BUCKET_NAME"
echo "DynamoDB Table: $DYNAMODB_TABLE_NAME"
