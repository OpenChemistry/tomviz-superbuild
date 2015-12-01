if (NOT tbb_libsuffix)
  set(tbb_libsuffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
  if (WIN32)
    set(tbb_libsuffix ${CMAKE_IMPORT_LIBRARY_SUFFIX})
  endif ()
endif ()

add_external_project_or_use_system(tbb
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dlibdir:STRING=${tbb_libdir}
      -Dlibsuffix:STRING=${tbb_libsuffix}
      -Dlibsuffixshared:STRING=${CMAKE_SHARED_LIBRARY_SUFFIX}
      -Dlibprefix:STRING=${CMAKE_SHARED_LIBRARY_PREFIX}
      ${tbb_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/tbb.install.cmake"

  ENABLED_DEFAULT ON
)

add_extra_cmake_args(
  -DTBB_INCLUDE_DIRS:PATH=<INSTALL_DIR>/include
  -DTBB_LIBRARIES:PATH=<INSTALL_DIR>/lib/libtbb${tbb_libsuffix}
  -DTBB_MALLOC_INCLUDE_DIRS:PATH=<INSTALL_DIR>/include
  -DTBB_MALLOC_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libtbb_malloc${tbb_libsuffix}
)
