set(_proc_env)
set(_patch_command)

if (APPLE)
  list(APPEND _proc_env "MACOSX_DEPLOYMENT_TARGET" "10.9")

# Horrible hack to force the configure step not to find getentropy and clock_gettime.
# If we build on a version that has these defined ( even as weak symbols ) they will
# be used and then we will get run time link errors when running on versions that
# don't actually have them defined ( such as 10.11 )
  list(APPEND _proc_env "ac_cv_func_getentropy" "no" "ac_cv_func_clock_gettime" "no")

  set(_patches_dir ${CMAKE_CURRENT_SOURCE_DIR}/projects/patches/python3.7/macos)
  set(_patch_command patch <SOURCE_DIR>/configure ${_patches_dir}/configure.patch && patch <SOURCE_DIR>/configure.ac ${_patches_dir}/configure.ac.patch)
endif()

add_external_project_or_use_system(python
  DEPENDS zlib
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-unicode=ucs4
                    --enable-shared
  PATCH_COMMAND ${_patch_command}
  PROCESS_ENVIRONMENT ${_proc_env}
  )
set (pv_python_executable "${install_location}/bin/python3" CACHE INTERNAL "" FORCE)

add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python3
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python3.7m
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython3.7m${CMAKE_SHARED_LIBRARY_SUFFIX}
  -DVTK_PYTHON_VERSION:STRING=3)

if (UNIX AND NOT APPLE)
  # Pass the -rpath flag when building python to avoid issues running the
  # executable we built.
  append_flags(LDFLAGS "-Wl,-rpath,${install_location}/lib" PROJECT_ONLY)
endif()

set (python_pip_executable "<INSTALL_DIR>/bin/pip3" CACHE INTERNAL "" FORCE)
