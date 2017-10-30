set(scipy_platform_string "cp36-cp36m-manylinux1_x86_64")
if (APPLE)
  set(scipy_platform_string "cp36-cp36m-macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.macosx_10_10_intel.macosx_10_10_x86_64")
endif()

add_external_project(scipy
  DEPENDS python numpy
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
  <INSTALL_DIR>/bin/pip3 install "scipy-0.19.0-${scipy_platform_string}.whl"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ""
)
