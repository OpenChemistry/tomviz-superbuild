# This is adapted from the ParaView common-superbuild
# Arguments after the first are dependencies

macro (superbuild_add_project_python _name)
  set(options INSTALL_WITH_PIP)
  set(oneValueArgs)
  set(multiValueArgs DEPENDS)
  cmake_parse_arguments(_OPTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(_OPTS_INSTALL_WITH_PIP)
    set(install_command ${python_pip_executable} install . --no-deps)
  else()
    set(install_command ${pv_python_executable} setup.py install
        --skip-build --prefix=<INSTALL_DIR>)
  endif()

  set(install_command_env)
  if (UNIX AND NOT APPLE)
    set(install_command_env env LD_LIBRARY_PATH=<INSTALL_DIR>/lib)
  endif()

  set(process_environment)
  if (UNIX AND NOT APPLE)
    set (process_environment PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<INSTALL_DIR>/lib")
  endif()

  add_external_project("${_name}"
    DEPENDS python ${_OPTS_DEPENDS}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND
      env
          CPPFLAGS=-I<INSTALL_DIR>/include
          LDFLAGS=-L<INSTALL_DIR>/lib
      ${pv_python_executable} setup.py build
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND
      ${install_command_env}
      ${install_command}
    ${process_environment}
  )
endmacro ()
