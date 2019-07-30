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
  vim

RUN useradd -c buildslave -d /home/buildslave -M buildslave &&\
    mkdir /home/buildslave &&\
    chown buildslave:buildslave /home/buildslave

USER buildslave

COPY install_cmake.sh /home/buildslave/install_cmake.sh
RUN sh /home/buildslave/install_cmake.sh

COPY make_itk_bundle.sh /home/buildslave/make_itk_bundle.sh

USER root

RUN chown buildslave:buildslave /home/buildslave/make_itk_bundle.sh && chmod +x /home/buildslave/make_itk_bundle.sh

USER buildslave

CMD /bin/bash
