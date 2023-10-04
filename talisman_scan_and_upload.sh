#!/bin/bash

# Set your S3 bucket name and desired object key
S3_BUCKET="zues2023"
OBJECT_KEY="new/talisman-scan-results.txt"

# Change to the Git repository directory
cd /home/ubuntu/joy/git-demo

# Run Talisman checks and capture the output
talisman

# Check if Talisman detected any issues
if [ $? -ne 0 ]; then
    echo "Talisman found issues. Uploading results to S3."
    
    # Create a temporary file to store Talisman output
    TMP_FILE=$(mktemp)
    talisman > "$TMP_FILE" 2>&1

    
    # Upload the results to S3
    aws s3 cp "$TMP_FILE" "s3://$S3_BUCKET/$OBJECT_KEY"
    
    # Clean up the temporary file
    rm "$TMP_FILE"
    
    echo "Results uploaded to S3."
else
    echo "No issues found by Talisman."
fi

# Continue with your Git commit process
git add .
git commit -m "Commit message"
git push

