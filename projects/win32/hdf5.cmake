include("${CMAKE_CURRENT_LIST_DIR}/../hdf5.cmake")

# On Windows, find_package(HDF5) with cmake 2.8.[8,9] always ends up finding
# the dlls instead of the libs. So setting the variables explicitly for
# dependent projects.
add_extra_cmake_args(
  -DHDF5_C_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/hdf5.lib
  -DHDF5_HL_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/hdf5_hl.lib
  # This variable is for CGNS, since CGNS doesn't use standard find_package()
  # to find hdf5.
  -DHDF5_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/hdf5.lib
  # These variables are for netcdf
  -DHDF5_LIB:FILEPATH=<INSTALL_DIR>/lib/hdf5.lib
  -DHDF5_HL_LIB:FILEPATH=<INSTALL_DIR>/lib/hdf5_hl.lib
  -DHDF5_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)

if (MSVC)
  # hdf5 has a bug with MSVC compiler where it doesn't realize its using MSVC
  # compiler when using nmake or ninja generators. This patch fixes that.
  set(_patch hdf5-msvc-non-vs-generator.patch)
  add_external_project_step("${_patch}"
    COMMAND "${GIT_EXECUTABLE}"
            apply
            --whitespace=fix
            -p1
            "${SuperBuild_PROJECTS_DIR}/patches/win32/${_patch}"
    WORKING_DIRECTORY <SOURCE_DIR>
    DEPENDEES update # do after update
    DEPENDERS patch  # do before patch
  )

  # VS2015 support
  set(_patch hdf5-vs2015-support.patch)
  add_external_project_step("${_patch}"
    COMMAND "${GIT_EXECUTABLE}"
            apply
            --whitespace=fix
            -p1
            "${SuperBuild_PROJECTS_DIR}/patches/win32/${_patch}"
    WORKING_DIRECTORY <SOURCE_DIR>
    DEPENDEES update # do after update
    DEPENDERS patch  # do before patch
  )
endif ()
