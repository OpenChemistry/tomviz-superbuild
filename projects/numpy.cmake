set (_install_location "<INSTALL_DIR>")
if (WIN32)
  # numpy build has issues with paths containing "C:". So we set the prefix as a
  # relative path.
  set (_install_location "../../../install")
endif()

set(NUMPY_PROCESS_ENVIRONMENT)
if(lapack_ENABLED)
  if(NOT LAPACK_FOUND)
    find_package(LAPACK REQUIRED)
  endif()
  list(APPEND NUMPY_PROCESS_ENVIRONMENT
    MKL "None"
    ATLAS "None"
    BLAS "<INSTALL_DIR>/lib"
    LAPACK "<INSTALL_DIR>/lib"
  )
endif()

set (numpy_extra_depends)
if (scipy_ENABLED)
  set (numpy_extra_depends lapack)
endif()

# If any variables are set, we must have the PROCESS_ENVIRONMENT keyword
if(NUMPY_PROCESS_ENVIRONMENT)
  list(INSERT NUMPY_PROCESS_ENVIRONMENT 0 PROCESS_ENVIRONMENT)
endif()

add_external_project(numpy
  DEPENDS python ${numpy_extra_depends}
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
    ${pv_python_executable} setup.py install --prefix=${_install_location}
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    ${pv_python_executable} setup.py build --fcompiler=${CMAKE_Fortran_COMPILER}
  ${NUMPY_PROCESS_ENVIRONMENT}
)
