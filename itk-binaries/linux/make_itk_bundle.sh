#!/bin/sh

set -e

readonly cmake_path=/home/buildslave/misc/root/cmake/bin

readonly itk_url="git://itk.org/ITK.git"
readonly target_tag="v5.0.1"

readonly tvsb_url="https://github.com/OpenChemistry/tomviz-superbuild.git"

readonly workdir="$HOME/dev/itk"

readonly tvsb_dir="$HOME/dev/tvsb"

mkdir -p "$tvsb_dir/build"
git clone "${tvsb_url}" "$tvsb_dir/src"

# Build a few dependencies from tomviz superbuild
# This is to ensure that the ITK is compatible with our numpy
cd "$tvsb_dir/build"
$cmake_path/cmake -DENABLE_tomviz:BOOL=OFF -DENABLE_tbb:BOOL=OFF -DENABLE_numpy:BOOL=ON "$tvsb_dir/src"
$cmake_path/cmake --build .

# Build ITK
mkdir -p "$workdir/build"
git clone "${itk_url}" "$workdir/src"
cd "$workdir/src"
git checkout ${target_tag}
cd "$workdir/build"
$cmake_path/cmake -DCMAKE_BUILD_TYPE:STRING=Release \
  -DITK_LEGACY_REMOVE:BOOL=ON \
  -DITK_LEGACY_SILENT:BOOL=ON \
  -DModule_ITKBridgeNumPy:BOOL=ON \
  -DBUILD_TESTING:BOOL=OFF \
  -DITK_WRAP_unsigned_short:BOOL=ON \
  -DITK_WRAP_rgb_unsigned_char:BOOL=OFF \
  -DITK_WRAP_rgba_unsigned_char:BOOL=OFF \
  -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
  -DITKGroup_Core:BOOL=ON \
  -DITKGroup_Filtering:BOOL=ON \
  -DITKGroup_Segmentation:BOOL=ON \
  -DITKGroup_Nonunit:BOOL=ON \
  -DITK_WRAP_PYTHON:BOOL=ON \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  "-DCMAKE_INSTALL_PREFIX:PATH=$workdir/install" \
  "-DPYTHON_LIBRARIES:FILEPATH=$tvsb_dir/build/install/lib/libpython3.7m.so" \
  "-DPYTHON_INCLUDE_DIR:PATH=$tvsb_dir/build/install/include/python3.7m" \
  "-DPYTHON_EXECUTABLE:FILEPATH=$tvsb_dir/build/install/bin/python3" \
  "-DNUMPY_INCLUDE_DIR:PATH=$tvsb_dir/build/install/lib/python3.7/site-packages/numpy/core/include" \
  "$workdir/src"

$cmake_path/cmake --build . -- -j8 && make install

cd "$workdir/install"
mkdir tmp
mv lib tmp/itk
mv tmp lib

cd "$workdir"
tar czf itk-${target_tag}-linux-64bit.tar.gz install

echo "ITK binary blob created at ${workdir}/itk-${target_tag}-linux-64bit.tar.gz"
