#!/bin/bash

# Run Talisman scan and capture the report in a variable
talisman_report=$(talisman --scan)

# Check if Talisman reported any issues
if [ $? -ne 0 ]; then
    # Save the report to a temporary file
    #echo "$talisman_report" > talisman_report.json

    # Upload the report to an S3 bucket
     aws s3 cp talisman_report/talisman_reports/data/report.json s3://zues2023/

    # Display a user-friendly message
    echo "Talisman scan report saved to S3: Please check 'talisman_report/talisman_reports/data' folder for the talisman scan report"

    # Parse and format the JSON report in a tabular format
    echo "Talisman Scan Report:"
    jq -r '.results[] | "File: \(.filename)\nType: \(.failure_list[].type)\nSeverity: \(.failure_list[].severity)\nMessage: \(.failure_list[].message)\n"' talisman_report/talisman_reports/data/report.json | column -t -s $'\n'

else
    # No issues found, display a message
    echo "Talisman scan found no issues."
fi

