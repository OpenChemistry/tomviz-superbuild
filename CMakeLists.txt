cmake_minimum_required(VERSION 3.6.1)
# We need  3.6.1 as opposed to 3.6.0 on Windows
# and we need 3.6 everywhere for a recursive submodules fix
# since ParaView now requires VTKm.  So I'm setting the minimum
# to 3.6.1 everywhere

if(NOT WIN32)
  enable_language(Fortran)
endif()

if(APPLE)
  if(NOT CMAKE_OSX_ARCHITECTURES)
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "By default, build for 64-bit")
  endif()

  if(NOT CMAKE_OSX_SDK)
    execute_process(
      COMMAND xcrun
              --show-sdk-version
      OUTPUT_VARIABLE
              SDK_VERSION
      RESULT_VARIABLE
              res
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(res)
      message(FATAL_ERROR "failed to detect CMAKE_OSX_SDK; please set manually (e.g. \"macosx10.10\")")
    endif()
    SET(CMAKE_OSX_SDK macosx${SDK_VERSION})
  endif()

  if(NOT CMAKE_OSX_SYSROOT)
    execute_process(
      COMMAND xcodebuild
              -sdk ${CMAKE_OSX_SDK}
              -version Path
      OUTPUT_VARIABLE
              CMAKE_OSX_SYSROOT
      RESULT_VARIABLE
              res
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(res)
      message(FATAL_ERROR "Cannot determine SDK path for SDK: ${CMAKE_OSX_SDK}")
    endif()
  endif()
  if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
    execute_process(
      COMMAND xcodebuild
              -sdk ${CMAKE_OSX_SDK}
              -version SDKVersion
      OUTPUT_VARIABLE
              CMAKE_OSX_DEPLOYMENT_TARGET
      RESULT_VARIABLE
              res
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(res)
      message(FATAL_ERROR "Cannot determine SDK version for SDK: ${CMAKE_OSX_SDK}")
    endif()
  endif()
endif()

project(TomvizSuperbuild)
set(SuperBuild_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
set(SuperBuild_PROJECTS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/projects")
set(SuperBuild_BINARY_DIR ${TomvizSuperbuild_BINARY_DIR})

set(BUILD_SHARED_LIBS ON  CACHE BOOL "Enable shared libraries")

include(CMakeDependentOption)

# Collect information about the build platform.
include(CheckTypeSize)
check_type_size(void* VOID_PTR_SIZE BUILTIN_TYPES_ONLY)
if(VOID_PTR_SIZE EQUAL 8)
  set(64bit_build TRUE)
else()
  set(64bit_build FALSE)
endif()

set(platform)
if(APPLE)
  set(platform "apple" "apple-unix")
  option(APPLY_MOUNTAIN_LION_FIX "Apply Mountain Lion bundle fix" OFF)
  mark_as_advanced(APPLY_MOUNTAIN_LION_FIX)
elseif(UNIX)
  set(platform "unix" "apple-unix")
elseif(WIN32)
  set(platform "win32")
endif()

# Setup CMAKE_MODULE_PATH so that platform specific configurations are processed
# before the generic ones.
set(tomviz_MODULE_PATH)
foreach(p IN LISTS platform)
  list(APPEND tomviz_MODULE_PATH "${SuperBuild_PROJECTS_DIR}/${p}")
endforeach()
set(CMAKE_MODULE_PATH
  ${tomviz_MODULE_PATH}
  "${SuperBuild_PROJECTS_DIR}/common"
  "${SuperBuild_PROJECTS_DIR}"
  "${SuperBuild_CMAKE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${CMAKE_MODULE_PATH})

# Download some sample data we would like to package
set(url_prefix "https://openchemistry.org/files/temdata")
file(DOWNLOAD ${url_prefix}/Recon_NanoParticle_doi_10.1021-nl103400a.emd
  ${CMAKE_BINARY_DIR}/Data/Recon_NanoParticle_doi_10.1021-nl103400a.emd
  EXPECTED_MD5 880ddb1417698d2f4aa675ceab374259)
file(DOWNLOAD ${url_prefix}/TiltSeries_NanoParticle_doi_10.1021-nl103400a.emd
  ${CMAKE_BINARY_DIR}/Data/TiltSeries_NanoParticle_doi_10.1021-nl103400a.emd
  EXPECTED_MD5 ce213127ca2ae9624d51a36e11b5a7eb)
set(tomviz_data ${CMAKE_BINARY_DIR}/Data)

# Setup some standard variables that control various locations and flags.
set(install_location "${CMAKE_CURRENT_BINARY_DIR}/install")
set(download_location "${CMAKE_CURRENT_BINARY_DIR}/downloads"
  CACHE PATH "Location where source tar-balls are (to be) downloaded.")
mark_as_advanced(download_location)

if(WIN32)
  set(ldflags)
  set(cppflags)
  set(cxxflags)
  set(ld_library_path)
else()
  # FIXME: currently, if any of these are empty, we have build issues on Unix.
  set(ldflags "$ENV{LDFLAGS} -L${install_location}/lib")
  set(cppflags "$ENV{CPPFLAGS} -fPIC")
  set(cxxflags "$ENV{CXXFLAGS} -fPIC")
  set(cflags "$ENV{CFLAGS} -fPIC")
  set(ld_library_path "${install_location}/lib:$ENV{LD_LIBRARY_PATH}")
endif()

if(APPLE)
  set(cflags "${cflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
  set(cppflags "${cppflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
  set(cxxflags "${cxxflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
endif()
set(prefix_path "${install_location}")

# merge in default/user-specified CMake flags.
set(ldflags "${CMAKE_SHARED_LINKER_FLAGS} ${ldflags}")
set(cppflags "${CMAKE_CXX_FLAGS} ${cppflags}")
set(cxxflags "${CMAKE_CXX_FLAGS} ${cxxflags}")
set(cflags "${CMAKE_C_FLAGS} ${cflags}")

string(STRIP "${ldflags}" ldflags)
string(STRIP "${cppflags}" cppflags)
string(STRIP "${cxxflags}" cxxflags)
string(STRIP "${cflags}"  cflags)
## Top-level options. These must be limited to a commonly used subset with
## default values being used for building tomviz binaries.
#option(PV_COMMAND_LINE_TOOLS_ONLY
#  "Turn this ON to build command lines tools alone." OFF)
if(WIN32)
  if((NOT "${CMAKE_GENERATOR}" MATCHES "^NMake.*$") OR
     (NOT "${CMAKE_GENERATOR}" MATCHES "^Visual Studio.*$"))
    # not use VS environment. We need to be pointed to nmake and devenv paths
    # since they are needed when building tools (qt, python, etc.)
    find_program(DEVENV_PATH devenv)
    find_program(NMAKE_PATH nmake)
    mark_as_advanced(DEVENV_PATH NMAKE_PATH)
  endif()
endif()

# Set from the top-level so that they can be changed more easily.
option(tomviz_FROM_GIT "If enabled Tomviz will be cloned using git" ON)
cmake_dependent_option(tomviz_FROM_SOURCE_DIR OFF
  "Enable to use existing tomviz source."
  "NOT tomviz_FROM_GIT" OFF)

# Force to build from a git tag for releases.
# set(tomviz_FROM_GIT ON)

#-----------------------------------------------------------------------------
include(ParaViewModules)
include(versions)
include(DetermineTomvizVersion)

# Enable testing support.
include(CTest)
configure_file(
  "${SuperBuild_CMAKE_DIR}/CTestCustom.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/CTestCustom.cmake" @ONLY)

#-----------------------------------------------------------------------------
set(CM_PROJECTS_ALL)

# Include all optional projects. These are the ones user can pick and choose.
# Some of these allow using system libraries too.
include(zlib)
if(UNIX AND NOT APPLE)
  include(freetype)
  include(fontconfig)
  include(png)
endif()
include(hdf5)
include(libxml2)
include(ffmpeg)
include(qt)
include(python)
include(cython)
include(pygments)
if(WIN32)
  include(intelredist)
endif()
include(numpy)
include(lapack)
include(scipy)
include(pkgconfig)
include(h5py)
include(itk)
include(fftw)
include(tbb)
include(pyfftw)
include(paraview)
include(tomviz)
include(marshmallow)
include(jsonpointer)
include(jsonpatch)

process_dependencies()

if(tomviz_ENABLED)
  include(tomviz.bundle OPTIONAL)
endif()
