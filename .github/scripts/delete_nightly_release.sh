#!/usr/bin/env bash

# If there is a "Latest" release and a "latest" tag that were not made
# today, delete them. A new one will be uploaded in a later step.

# Turn off errors in case the latest doesn't exist
set +e

# Enter the superbuild directory
cd tomviz-superbuild

# We apparently have to set this environment variable to any value to use hub
# See https://github.com/github/hub/issues/2149
export GITHUB_USER=openchemistry

# Check if today's latest release has already been created
hub_output=$(hub release show latest)

echo "hub_output is: $hub_output"
echo "NIGHTLY_DATE is $NIGHTLY_DATE"

# This should have the latest date in its body if it was made today.
if [[ ! -z "$hub_output" ]] && [[ "$hub_output" != *"$NIGHTLY_DATE"* ]]; then
  echo "Deleting previous latest"

  # It has not already been created. Delete the old one, if present.
  hub release delete Latest
  hub push origin latest --delete
  git tag -d latest
else
  echo "Not deleting latest (either it did not exist or it is up-to-date)"
fi

exit 0
