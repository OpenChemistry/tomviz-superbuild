#!/usr/bin/env bash

# Make the release directory, which will contain everything to be uploaded
mkdir release

if [[ $RUNNER_OS == "Linux" ]]; then
  # Add "-Linux" to the name before the extension, to avoid a name
  # clash with the source tarball.
  tarball_file=$(ls build/Tomviz*.tar.gz)
  tarball_basename=$(basename $tarball_file)
  # Since we know the extension is 7 characters, just remove the last 7 characters
  without_extension="${tarball_basename::-7}"
  new_name=$without_extension-Linux.tar.gz
  mv $tarball_file build/$new_name

  # Make the source tarball and prepare it to be uploaded
  # We will use the same name as "without_extension", except lowercase the t
  source_name=t${without_extension:1}

  # Ensure all submodules are present, and remove all `.git` folders
  mkdir source-tarball
  pushd .
  cd source-tarball
  git clone --recursive --depth 1 https://github.com/openchemistry/tomviz $source_name

  # Remove all .git folders
  find . -name ".git" | xargs rm -rf

  # Create the tarball
  tar -czf $source_name.tar.gz $source_name

  # Move it to the release directory
  mv $source_name.tar.gz ../release
  popd
fi

# Move all Tomviz* files to the release directory
mv build/Tomviz* release/
