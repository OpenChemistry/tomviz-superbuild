FROM debian:8

COPY install_deps.sh /install_deps.sh
RUN sh /install_deps.sh

COPY install_cmake.sh /install_cmake.sh
RUN sh /install_cmake.sh

COPY install_qt.sh /install_qt.sh
RUN sh /install_qt.sh