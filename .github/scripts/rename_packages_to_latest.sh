#!/usr/bin/env bash

# Rename all "Tomviz-*.<ext>" packages to "tomviz-latest.<ext>"

for f in ./build/Tomviz-*; do
  filename=$(basename $f)
  extension=${filename##*.}

  if [[ "$extension" == "gz" ]]; then
    # This should actually be tar.gz on Linux
    extension="tar.gz"
  fi

  target="./build/tomviz-latest.$extension"
  echo "Moving $f to $target"
  mv $f $target
done
