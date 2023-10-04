#!/bin/bash

# Set your S3 bucket name and desired object key
S3_BUCKET="zues2023"
OBJECT_KEY="new/talisman-scan-results.txt"

# Run Talisman checks
talisman_output=$(talisman 2>&1)

# Check if Talisman detected any issues
if [ $? -ne 0 ]; then
    echo "Talisman found issues. Uploading results to S3."

    # Create a temporary directory to store Talisman output
    TMP_DIR=$(mktemp -d)

    # Output Talisman's findings to a temporary file in the temporary directory
    echo "$talisman_output" > "$TMP_DIR/talisman-output.txt"

    # Check if the temporary file exists
    if [ -f "$TMP_DIR/talisman-output.txt" ]; then
        # Upload the results to S3
        aws s3 cp "$TMP_DIR/talisman-output.txt" "s3://$S3_BUCKET/$OBJECT_KEY"

        # Clean up the temporary directory
        rm -r "$TMP_DIR"

        echo "Results uploaded to S3."
    else
        echo "Error: Temporary file not found."
    fi
else
    echo "No issues found by Talisman."
    echo "Proceed with git add, git commit, and git push."
fi

