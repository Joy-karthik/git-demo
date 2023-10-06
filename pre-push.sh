#!/bin/bash

# Run Talisman scan
talisman --scan

# Check if Talisman reported any issues
if [ $? -eq 0 ]; then
    # Save the report to a temporary file
    talisman --scan > talisman_report.txt

    # Upload the report to an S3 bucket
    aws s3 cp talisman_report.txt s3://zues2023/
fi
