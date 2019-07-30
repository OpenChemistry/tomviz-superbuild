#!/bin/bash

set -e

readonly basedir=$PWD

readonly cmake_path=/usr/local/bin

readonly itk_url="git://itk.org/ITK.git"
readonly target_tag="v5.0.1"

readonly tvsb_url="https://github.com/OpenChemistry/tomviz-superbuild.git"

readonly workdir="$basedir/dev/itk"

readonly tvsb_dir="$basedir/dev/tvsb"

mkdir -p "$tvsb_dir/build"
if [ ! -e "$tvsb_dir/src" ]; then
	git clone "${tvsb_url}" "$tvsb_dir/src"
fi

# Build a few dependencies from tomviz superbuild
# This is to ensure that the ITK is compatible with our numpy
cd "$tvsb_dir/build"
$cmake_path/cmake \
  -DENABLE_tomviz:BOOL=OFF \
  -DENABLE_tbb:BOOL=OFF \
  -DENABLE_numpy:BOOL=ON \
  -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.9 \
  "$tvsb_dir/src"

$cmake_path/cmake --build .

# Build ITK
mkdir -p "$workdir/build"
if [ ! -e "$workdir/src" ]; then
	git clone "${itk_url}" "$workdir/src"
fi
cd "$workdir/src"
git checkout $target_tag
cd "$workdir/build"
$cmake_path/cmake -DCMAKE_BUILD_TYPE:STRING=Release \
  -DITK_LEGACY_REMOVE:BOOL=ON \
  -DITK_LEGACY_SILENT:BOOL=ON \
  -DModule_ITKBridgeNumPy:BOOL=ON \
  -DBUILD_TESTING:BOOL=OFF \
  -DITK_WRAP_PYTHON:BOOL=ON \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  "-DCMAKE_INSTALL_PREFIX:PATH=$workdir/install" \
  "-DPYTHON_LIBRARIES:FILEPATH=$tvsb_dir/build/install/lib/libpython3.7m.dylib" \
  "-DPYTHON_INCLUDE_DIR:PATH=$tvsb_dir/build/install/include/python3.7m" \
  "-DPYTHON_EXECUTABLE:FILEPATH=$tvsb_dir/build/install/bin/python3" \
  "-DNUMPY_INCLUDE_DIR:PATH=$tvsb_dir/build/install/lib/python3.7/site-packages/numpy/core/include" \
  -DITK_WRAP_unsigned_short:BOOL=ON \
  -DITK_USE_SYSTEM_SWIG:BOOL=ON \
  -DCMAKE_OSX_ARCHITECTURES=x86_64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
  -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk \
  -DCMAKE_SKIP_INSTALL_RPATH=OFF \
  -DCMAKE_SKIP_RPATH=OFF \
  "$workdir/src"

make -j8 && make install

cd "$workdir/install"
mkdir tmp
mv lib tmp/itk
mv tmp lib

cd "$workdir"
tar czf itk-${target_tag}-osx-64bit.tar.gz install

mv itk-${target_tag}-osx-64bit.tar.gz ${basedir}/

echo "ITK binary blob created at ${basedir}/itk-${target_tag}-osx-64bit.tar.gz"
