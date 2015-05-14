#!/bin/sh

# This script performs magic and builds an FFmpeg for Windows for 32- and
# 64-bit. It will drop `ffmpeg-kitware-*.tar.bz2` files in the current
# directory. Have fun! :)

# Run this from the top-level of an FFmpeg git checkout. Requires mingw
# cross-compilers and a static pthread library for each. Arguments to this
# script are passed to `make`.

# We use `-e` so that if anything fails, the entire script fails immediately.
set -e
# The `-x` is nice so that what is happening is visible.
set -x

# Gather information used in the tarball names.
date="$( date +"%Y%m%d" )"
hash="$( git rev-parse --short HEAD )"

# Paths used during the builds.
sourceroot="$PWD"
buildroot="$sourceroot/build-windows"
installroot="$buildroot/install"

# Utility function for erroring out.
die () {
    echo >&2 "$@"
    exit 1
}

# Make sure that the configure script exists.
[ -x "$sourceroot/configure" ] || \
    die "Run this script from the root of the source tree"

# Clear the existing build trees.
rm -rf "$buildroot"
mkdir -p "$buildroot"
mkdir -p "$installroot"

# Build settings.
makeflags="$@"
ffmpegflags="--enable-shared --enable-memalign-hack --enable-runtime-cpudetect --disable-bzlib --enable-zlib --disable-avdevice --disable-decoders --disable-doc --disable-ffplay --disable-ffprobe --disable-ffserver --disable-network --disable-yasm --extra-cflags=-static --extra-ldflags=-static"

# The build function.
build_for_windows () {
    target="$1"
    shift

    arch="$1"
    shift

    builddir="$buildroot/$target"
    installdir="$installroot/$target"

    # Set up the build tree.
    mkdir -p "$builddir"

    curdir="$builddir"
    cd "$builddir"
    "$sourceroot/configure" --prefix="$installdir" \
        --cross-prefix="$arch-w64-mingw32-" --sysroot="/usr/$arch-w64-mingw32/sys-root" \
        --target-os=mingw32 --arch="$arch" --pkg-config=pkg-config \
        $ffmpegflags
    make $makeflags
    make install
    cd "$curdir"
}

clean_inline_keywords () {
    dir="$1/include"
    shift

    sed -i -e 's/static inline /static __inline /' \
        "$dir/libavutil/avutil.h" \
        "$dir/libavutil/fifo.h" \
        "$dir/libavutil/lfg.h" \
        "$dir/libavutil/rational.h" \
        "$dir/libavutil/bswap.h" \
        "$dir/libavutil/timestamp.h" \
        "$dir/libavutil/bprint.h" \
        "$dir/libavutil/mem.h" \
        "$dir/libavutil/error.h" \
        "$dir/libavutil/avstring.h"
}

make_tarball () {
    target="$1"
    shift

    installdir="$installroot/$target"
    clean_inline_keywords "$installdir"

    # Tar up the install tree into a tarbomb. The tarball should have the
    # `bin`, `lib`, etc. directories directly in it.
    tar cjf "$sourceroot/ffmpeg-kitware-${date}git${hash}-$target.tar.bz2" -C "$installroot" "$target"
}

# Build for 32-bit.
build_for_windows win32 i686
# Build for 64-bit.
build_for_windows win64 x86_64

# Make tarballs of the results.
make_tarball win32
make_tarball win64

# Make a source tarball for non-Windows builds.
cd "$sourceroot"
git archive --format=tar "$hash" | \
    bzip2 > "ffmpeg-kitware-${date}git${hash}-src.tar.bz2"
