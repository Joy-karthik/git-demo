#!/bin/bash

# Run Talisman
talisman --scan

# Check if Talisman detected issues
if [ $? -ne 0 ]; then
    # Create a temporary directory to save files
    tmp_dir=$(mktemp -d)

    # Copy the relevant files to the temporary directory
    # Example: cp path/to/talisman_issues.txt $tmp_dir/

    # Upload the files to the S3 bucket
    aws s3 cp $tmp_dir s3://zues2023/

    # Clean up temporary directory
    rm -r $tmp_dir
fi

