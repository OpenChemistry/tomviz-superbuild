set (_install_location "<INSTALL_DIR>")

set(SCIPY_PROCESS_ENVIRONMENT)
list(APPEND SCIPY_PROCESS_ENVIRONMENT
    PYTHONPATH "${_install_location}/lib/python3.6/site-packages")
if(lapack_ENABLED)
  if(USE_SYSTEM_lapack AND NOT LAPACK_FOUND)
    find_package(LAPACK REQUIRED)
  endif()
  list(APPEND SCIPY_PROCESS_ENVIRONMENT
    BLAS "<INSTALL_DIR>/lib"
    LAPACK "<INSTALL_DIR>/lib"
  )
  if (UNIX AND NOT APPLE)
    list(APPEND SCIPY_PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<INSTALL_DIR>/lib"
    )
  endif()
endif()

set(scipy_install_env)
if(UNIX AND NOT APPLE)
  set(scipy_install_env env LD_LIBRARY_PATH=<INSTALL_DIR>/lib)
endif()

set(SKIP_LDFLAGS_FOR_BUILD TRUE)

add_external_project(scipy
    DEPENDS python numpy lapack
    CONFIGURE_COMMAND ""
    INSTALL_COMMAND
      ${scipy_install_env}
      ${pv_python_executable} setup.py install --prefix=${_install_location}
    BUILD_IN_SOURCE 1
    BUILD_COMMAND
      ${pv_python_executable} setup.py config_fc build
    PROCESS_ENVIRONMENT
      ${SCIPY_PROCESS_ENVIRONMENT}
)
