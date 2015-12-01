# Install headers
file(INSTALL
  "${source_location}/include/"
  DESTINATION "${install_location}/include"
  PATTERN "index.html" EXCLUDE)

# Remove rpath junk
if (APPLE)
  file(GLOB libraries "${source_location}/${libdir}/*.dylib")
  foreach (library IN LISTS libraries)
    get_filename_component(filename "${library}" NAME)
    execute_process(
      COMMAND install_name_tool
              -id "${library}"
              "${library}")
  endforeach ()
endif ()

# Install libraries
file(INSTALL
  "${source_location}/${libdir}/"
  DESTINATION "${install_location}/lib"
  FILES_MATCHING
    PATTERN "${libprefix}tbb${libsuffix}"
    PATTERN "${libprefix}tbbmalloc${libsuffix}")

if (WIN32)
  # Install DLLs
  string(REPLACE "lib" "bin" bindir "${libdir}")
  file(INSTALL
    "${source_location}/${bindir}/${libprefix}tbb${libsuffixshared}"
    "${source_location}/${bindir}/${libprefix}tbbmalloc${libsuffixshared}"
    DESTINATION "${install_location}/bin")
endif ()
