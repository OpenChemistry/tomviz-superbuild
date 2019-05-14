add_external_project_or_use_system(hdf5
  DEPENDS zlib

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=FALSE
    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=FALSE
    -DHDF5_BUILD_HL_LIB:BOOL=TRUE
    -DHDF5_BUILD_WITH_INSTALL_NAME:BOOL=ON)

add_extra_cmake_args(
  -DHDF5_ROOT:PATH=<INSTALL_DIR>
  -DHDF5_NO_FIND_PACKAGE_CONFIG_FILE:BOOL=ON)

set(_patch hdf5-fix-ext-pkg-find.patch)
add_external_project_step("${_patch}"
  COMMAND "${GIT_EXECUTABLE}"
          apply
          --whitespace=fix
          -p1
          "${SuperBuild_PROJECTS_DIR}/patches/${_patch}"
  WORKING_DIRECTORY <SOURCE_DIR>
  DEPENDEES update # do after update
  DEPENDERS patch  # do before patch
)
