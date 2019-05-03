add_external_project_or_use_system(hdf5
  DEPENDS zlib szip

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=TRUE
    -DHDF5_BUILD_HL_LIB:BOOL=TRUE
    -DHDF5_BUILD_WITH_INSTALL_NAME:BOOL=ON)

add_extra_cmake_args(
  -DHDF5_ROOT:PATH=<INSTALL_DIR>
  -DHDF5_NO_FIND_PACKAGE_CONFIG_FILE:BOOL=ON)

#superbuild_apply_patch(hdf5 fix-ext-pkg-find
#  "Force proper logic for zlib and szip dependencies")
