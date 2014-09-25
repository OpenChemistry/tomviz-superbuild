if (WIN32)
  message(FATAL_ERROR "pyFFTW must be installed separately on Windows")
endif ()

add_external_project(pyfftw
  DEPENDS python numpy fftw3float fftw3double fftw3long
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    env
        CPPFLAGS=-I<INSTALL_DIR>/include
        LDFLAGS=-L<INSTALL_DIR>/lib
    ${pv_python_executable} setup.py build
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND
  ${pv_python_executable} setup.py install --prefix=<INSTALL_DIR>
)
