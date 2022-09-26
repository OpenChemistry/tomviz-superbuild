#!/usr/bin/env bash

# If there is a "Nightly" release and a "nightly" tag that were not made
# today, delete them. A new one will be uploaded in a later step.

# Turn off errors in case the nightly doesn't exist
set +e

# Enter the superbuild directory
cd tomviz-superbuild

# Check if today's nightly release has already been created
hub_output=$(hub release show nightly)

# This should have the nightly date in its body if it was made today.
if [[ ! -z "$hub_output" ]] && [[ "$hub_output" != *"$NIGHTLY_DATE"* ]]; then
  # It has not already been created. Delete the old one, if present.
  hub release delete Nightly
  hub push origin nightly --delete
  git tag -d nightly
fi

exit 0
