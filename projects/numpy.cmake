set(numpy_platform_string "cp36-cp36m-manylinux1_x86_64")
if (APPLE)
  set(numpy_platform_string "cp36-cp36m-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64")
endif()

add_external_project(numpy
  DEPENDS python
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
  <INSTALL_DIR>/bin/pip3 install "numpy-1.14.0-${numpy_platform_string}.whl"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
)
