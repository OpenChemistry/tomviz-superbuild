#!/bin/sh

set -e

readonly common_sb_url="https://gitlab.kitware.com/paraview/common-superbuild.git"
readonly commit="ac3b02c7975511cbd594b4aab57329a4789c1649"

readonly workdir="$HOME/misc/code/qt5"
readonly srcdir="$workdir/src"
readonly builddir="$workdir/build"

mkdir -p "$builddir"
git clone "${common_sb_url}" "$srcdir"
cd "$srcdir"
git checkout "$commit"

cd "$builddir"
/cmake/bin/cmake \
  -DENABLE_qt5:BOOL=ON \
  "-Dqt_install_location:PATH=$HOME/support/qt5" \
  -Dqt5_ENABLE_SVG:BOOL=ON \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  "$srcdir/standalone-qt"
make -j8

rm -rf $workdir
