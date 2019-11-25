set(install_command_env)
if (UNIX AND NOT APPLE)
  set(install_command_env env LD_LIBRARY_PATH=<INSTALL_DIR>/lib)
endif()

set(process_environment)
if (UNIX AND NOT APPLE)
  set (process_environment PROCESS_ENVIRONMENT
    LD_LIBRARY_PATH "<INSTALL_DIR>/lib")
endif()

add_external_project(pygments
  DEPENDS python
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    "${CMAKE_COMMAND}" -E env
        CPPFLAGS=-I<INSTALL_DIR>/include
        LDFLAGS=-L<INSTALL_DIR>/lib
    ${pv_python_executable} setup.py build
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND
    ${install_command_env}
  ${python_pip_executable} install .
  ${process_environment}
)
