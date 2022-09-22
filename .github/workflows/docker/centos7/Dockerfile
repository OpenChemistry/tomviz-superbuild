FROM centos:7

COPY install_deps.sh /root/install_deps.sh
RUN sh /root/install_deps.sh

COPY install_cmake.sh /root/install_cmake.sh
RUN scl enable devtoolset-7 /root/install_cmake.sh

COPY install_qt.sh /root/install_qt.sh
RUN scl enable devtoolset-7 /root/install_qt.sh
