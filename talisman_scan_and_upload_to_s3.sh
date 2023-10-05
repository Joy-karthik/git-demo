#!/bin/bash

# Run Talisman and capture its output
talisman_output=$(talisman --scan 2>&1)

# Always generate the report
report_file=/home/ubuntu/joy/git-demo/talisman_report/talisman_reports/data/report.json
echo "$talisman_output" > "$report_file"

# Upload the report to S3 using the AWS CLI
aws s3 cp "$report_file" s3://zues2023/talisman_reports/

# Check if Talisman found any issues
if [[ $talisman_output == *"Talisman Report:"* ]]; then
    echo "Talisman found issues."
else
    echo "No issues found by Talisman."
fi

