#!/bin/sh

set -e

# Install build requirements.
yum install -y \
    zlib-devel libcurl-devel python-devel \
    freeglut-devel glew-devel graphviz-devel libpng-devel \
    libxcb-devel libXt-devel xcb-util-wm-devel xcb-util-devel \
    xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel \
    libXcursor-devel mesa-libGL-devel mesa-libEGL-devel \
    libxkbcommon-devel libxkbcommon-x11-devel file mesa-dri-drivers autoconf \
    automake libtool chrpath bison flex libXrandr-devel libffi-devel

# Install EPEL
yum install -y \
    epel-release

# Install development tools
yum install -y \
    git-lfs

# Install toolchains.
yum install -y \
    centos-release-scl
yum install -y \
    devtoolset-7-gcc-c++ \
    devtoolset-7 \
    devtoolset-7-gcc \
    devtoolset-7-gfortran \
    rh-git227-git-core

yum clean all
