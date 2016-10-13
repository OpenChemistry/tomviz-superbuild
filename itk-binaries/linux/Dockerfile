FROM debian:8
MAINTAINER Shawn Waldon <shawn.waldon@kitware.com>

# Install packages
RUN apt-get update && apt-get install -y \
  gcc \
  g++ \
  gfortran \
  python-pip \
  python-dev \
  git \
  libcurl4-openssl-dev \
  curl \
  libxt-dev \
  libx11-dev \
  libglu1-mesa-dev \
  libxext-dev \
  libz-dev \
  xkb-data \
  python-virtualenv \
  pkg-config \
  libfontconfig1-dev

RUN useradd -c buildslave -d /home/buildslave -M buildslave &&\
    mkdir /home/buildslave &&\
    chown buildslave:buildslave /home/buildslave

COPY make_itk_bundle.sh /home/buildslave/make_itk_bundle.sh
RUN chown buildslave:buildslave /home/buildslave/make_itk_bundle.sh && chmod +x /home/buildslave/make_itk_bundle.sh

USER buildslave

COPY install_cmake.sh /home/buildslave/install_cmake.sh
RUN sh /home/buildslave/install_cmake.sh

CMD /bin/bash
