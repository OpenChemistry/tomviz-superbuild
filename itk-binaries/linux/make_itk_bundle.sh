#!/bin/sh

set -e

readonly cmake_path=/home/buildslave/misc/root/cmake/bin

readonly itk_url="git://itk.org/ITK.git"
readonly target_tag="v4.12.0"

readonly tvsb_url="https://github.com/OpenChemistry/tomviz-superbuild.git"

readonly workdir="$HOME/dev/itk"

readonly tvsb_dir="$HOME/dev/tvsb"

mkdir -p "$tvsb_dir/build"
git clone "${tvsb_url}" "$tvsb_dir/src"

# Build a few dependencies from tomviz superbuild
# This is to ensure that the ITK is compatible with our numpy and fftw
cd "$tvsb_dir/build"
$cmake_path/cmake -DENABLE_tomviz:BOOL=OFF -DENABLE_tbb:BOOL=OFF -DENABLE_pyfftw:BOOL=ON -DENABLE_numpy:BOOL=ON "$tvsb_dir/src"
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
  -DITK_USE_FFTWD:BOOL=ON \
  -DITK_USE_FFTWF:BOOL=ON \
  -DModule_BridgeNumPy:BOOL=ON \
  -DBUILD_TESTING:BOOL=OFF \
  -DITK_WRAP_PYTHON:BOOL=ON \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  "-DCMAKE_INSTALL_PREFIX:PATH=$workdir/install" \
  "-DNUMPY_INCLUDE_DIR:PATH=$tvsb_dir/build/install/lib/python3.6/site-packages/numpy/core/include" \
  "-DFFTWD_LIB:FILEPATH=$tvsb_dir/build/install/lib/libfftw3.a" \
  "-DFFTWD_THREADS_LIB:FILEPATH=$tvsb_dir/build/install/lib/libfftw3_threads.a" \
  "-DFFTWF_LIB:FILEPATH=$tvsb_dir/build/install/lib/libfftw3f.a" \
  "-DFFTWF_THREADS_LIB:FILEPATH=$tvsb_dir/build/install/lib/libfftw3f_threads.a" \
  "-DFFTW_INCLUDE_PATH:PATH=$tvsb_dir/build/install/include" \
  -DITK_WRAP_unsigned_short:BOOL=ON \
  "$workdir/src"

$cmake_path/cmake --build . && make install

cd "$workdir/install"
mkdir tmp
mv lib tmp/itk
mv tmp lib

cd "$workdir"
tar czf itk-${target_tag}-linux-64bit.tar.gz install

echo "ITK binary blob created at ${workdir}/itk-${target_tag}-linux-64bit.tar.gz"
