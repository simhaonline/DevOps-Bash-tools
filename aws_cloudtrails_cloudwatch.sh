#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-01-17 16:24:52 +0000 (Fri, 17 Jan 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Lists Cloud Trails and their last delivery to CloudWatch Logs (should be recent)
#
# Output Format:
#
# CloudTrail_Name      LastDeliveryTimestampToCloudWatchLogs (may be null)

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

#echo "Getting Cloud Trails" >&2
aws cloudtrail describe-trails |
jq -r '.trailList[].Name' |
while read -r name; do
    printf "%s\t" "$name"
    output="$(aws cloudtrail get-trail-status --name "$name" | jq -r '.LatestcloudwatchLogdDeliveryTime')"
    if [ -n "$output" ]; then
        echo "$output"
        echo "$output"
    else
        echo "NOT_LOGGING"
    fi
done |
sort |
column -t
