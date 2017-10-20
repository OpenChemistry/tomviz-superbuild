# This needs to set a the following variables which are using in various
# bundling codes to determine tomviz version.
#   tomviz_version_major
#   tomviz_version_minor
#   tomviz_version_patch
#   tomviz_version_suffix
#   tomviz_version
#   tomviz_version_long

set(hardcoded_tomviz_version "1.2.0")

function(_set_version_vars versiontext)
  string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)[-]*(.*)" version_matches "${versiontext}")
  if(CMAKE_MATCH_0)
    set(full ${CMAKE_MATCH_0})
    set(major ${CMAKE_MATCH_1})
    set(minor ${CMAKE_MATCH_2})
    set(patch ${CMAKE_MATCH_3})
    set(patch_extra ${CMAKE_MATCH_4})

    set(tomviz_version "${major}.${minor}.${patch}" PARENT_SCOPE)
    set(tomviz_version_major ${major} PARENT_SCOPE)
    set(tomviz_version_minor ${minor} PARENT_SCOPE)
    set(tomviz_version_patch ${patch} PARENT_SCOPE)
    set(tomviz_version_suffix ${patch_extra} PARENT_SCOPE)
    set(tomviz_version_long ${full} PARENT_SCOPE)
  endif()
endfunction()

if(tomviz_FROM_SOURCE_DIR)
  # We can use GitDescribe in this case, so let's use it.

  # First, set the vars using the hard coded version if everything fails.
  _set_version_vars(${hardcoded_tomviz_version})
  include("${tomviz_SOURCE_DIR}/cmake/Git.cmake" OPTIONAL)
  include("${tomviz_SOURCE_DIR}/cmake/tomvizDetermineVersion.cmake" OPTIONAL
    RESULT_VARIABLE status)
  if(status)
    message(STATUS "Using git-describe to determine tomviz version")
    # the tomviz module was correctly imported.
    determine_version("${tomviz_SOURCE_DIR}" "${GIT_EXECUTABLE}" "__TMP")
    if(__TMP_VERSION_FULL)
      _set_version_vars(${__TMP_VERSION_FULL})
    endif()
  endif()

  # make the TOMVIZ_VERSION variable internal to avoid confusion.
  set(TOMVIZ_VERSION "${hardcoded_tomviz_version}" CACHE INTERNAL "")
else()
  # The user has to specify the version to use.
  set(TOMVIZ_VERSION "${hardcoded_tomviz_version}" CACHE STRING
    "Specify the version number for the package being generated e.g. ${hardcoded_tomviz_version}")
  mark_as_advanced(TOMVIZ_VERSION)
  _set_version_vars(${TOMVIZ_VERSION})
endif()

message(STATUS "Using tomviz Version: ${tomviz_version_long} (${tomviz_version_major}|${tomviz_version_minor}|${tomviz_version_patch}|${tomviz_version_suffix})")
