if (WIN32)
  message(FATAL_ERROR "pyFFTW must be installed separately on Windows")
endif ()

set(install_command_env)
if (UNIX AND NOT APPLE)
  set(install_command_env env LD_LIBRARY_PATH=<INSTALL_DIR>/lib)
endif()

set(process_environment)
if (UNIX AND NOT APPLE)
  set (process_environment PROCESS_ENVIRONMENT
    LD_LIBRARY_PATH "<INSTALL_DIR>/lib")
endif()

# the --single-version-externally-managed flag gets pyfftw to install
# as a module rather than a python egg.  But it requires an install
# record file so I gave it one.
set(extra_install_args)
if (APPLE)
  set(extra_install_args
     --record=<INSTALL_DIR>/pyfftw_install.txt
     --single-version-externally-managed)
endif()

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
    ${install_command_env}
  ${pv_python_executable} setup.py install
     --prefix=<INSTALL_DIR>
     ${extra_install_args}
  ${process_environment}
)
