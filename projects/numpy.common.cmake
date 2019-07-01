add_external_project(numpy
  DEPENDS python
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
  ${python_pip_executable} install "numpy-1.16.3-${numpy_platform_string}.whl"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
)
