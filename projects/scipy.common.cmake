add_external_project(scipy
  DEPENDS python numpy
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
  ${python_pip_executable} install "scipy-1.2.1-${scipy_platform_string}.whl"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
)
