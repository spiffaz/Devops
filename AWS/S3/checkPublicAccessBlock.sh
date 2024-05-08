#!/bin/bash

# Get a list of all S3 buckets in the account
buckets=$(aws s3api list-buckets --query "Buckets[*].Name" --output text)

# Iterate over each bucket and check block all public access
for bucket in $buckets
do
    echo "Checking block all public access for bucket: $bucket"
    
    block_public_access=$(aws s3api get-public-access-block --bucket "$bucket" --query "PublicAccessBlockConfiguration" --output text 2>/dev/null)
    
    if [[ -n "$block_public_access" ]]; then
        echo "Block all public access is enabled for bucket $bucket"
        echo "$block_public_access"
    else
        echo "Block all public access is not enabled for bucket $bucket"
    fi

    echo "------------------------"
done
