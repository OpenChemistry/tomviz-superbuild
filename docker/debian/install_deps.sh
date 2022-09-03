#!/bin/sh

# Install dependent packages
apt-get update
apt-get install -y \
  gcc \
  g++ \
  gfortran \
  python-pip \
  python-dev \
  git \
  libcurl4-openssl-dev \
  curl \
  libffi-dev \
  libxt-dev \
  libx11-dev \
  libglu1-mesa-dev \
  libxext-dev \
  libz-dev \
  xkb-data \
  python-virtualenv \
  pkg-config \
  libfontconfig1-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-dev
apt-get clean
