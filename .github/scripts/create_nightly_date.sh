#!/usr/bin/env bash

# Get the date for yesterday (which is what the nightly would have
# been generated for).

if [[ $RUNNER_OS == "macOS" ]]; then
  # Mac has a slightly different date than Linux
  NIGHTLY_DATE=$(date -v -1d '+%m-%d-%Y')
else
  NIGHTLY_DATE=$(date '+%m-%d-%Y' -d 'yesterday')
fi

echo "NIGHTLY_DATE=$NIGHTLY_DATE" >> $GITHUB_ENV
