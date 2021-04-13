set(proj HoloPlayCore)
set(name holoplay)

set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${name}/${proj})

add_external_project(${name}
    SOURCE_DIR ${EP_BINARY_DIR}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

set(${proj}_INCLUDE_DIR "${EP_BINARY_DIR}/HoloPlayCore/include")
if(APPLE)
  set(_dir "macos")
  set(_prefix "lib")
  set(_ext "dylib")
elseif(UNIX)
  set(_dir "linux")
  set(_prefix "lib")
  set(_ext "so")
else()
  set(_dir "Win64")
  set(_prefix "")
  set(_ext "lib")
endif()
set(_library_dir "${EP_BINARY_DIR}/HoloPlayCore/dylib/${_dir}")
set(${proj}_LIBRARY "${_library_dir}/${_prefix}HoloPlayCore.${_ext}")
