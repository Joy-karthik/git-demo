#!/bin/bash

# Run Talisman scan and capture the report in a variable
talisman_report=$(talisman --scan)

# Check if Talisman reported any issues
if [ $? -ne 0 ]; then
    # Save the report to a temporary file
    echo "$talisman_report" > talisman_report.json

    # Upload the report to an S3 bucket
    aws s3 cp talisman_report.txt s3://zues2023/
fi

