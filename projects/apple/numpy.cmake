set(numpy_platform_string "cp37-cp37m-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64")

add_external_project(numpy
  DEPENDS python
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
  ${python_pip_executable} install -U pip
  COMMAND ${python_pip_executable} install "numpy-1.16.3-${numpy_platform_string}.whl"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
)
