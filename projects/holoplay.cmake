set(proj HoloPlayCore)
set(name holoplay)

set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${name}/${proj})

set(${proj}_INCLUDE_DIR "${EP_BINARY_DIR}/HoloPlayCore/include")
if(APPLE)
  set(_dir "macos")
  set(_prefix "lib")
  set(_ext "dylib")
  set(_runtime_ext "dylib")
elseif(UNIX)
  set(_dir "linux")
  set(_prefix "lib")
  set(_ext "so")
  set(_runtime_ext "so")
else()
  set(_dir "Win64")
  set(_prefix "")
  set(_ext "lib")
  set(_runtime_ext "dll")
endif()
set(_library_dir "${EP_BINARY_DIR}/HoloPlayCore/dylib/${_dir}")
set(${proj}_LIBRARY "${_library_dir}/${_prefix}HoloPlayCore.${_ext}")
set(${proj}_RUNTIME_LIBRARY "${_library_dir}/${_prefix}HoloPlayCore.${_runtime_ext}")

add_external_project(${name}
    SOURCE_DIR ${EP_BINARY_DIR}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}"
        "-Dinstall_dir:PATH=<INSTALL_DIR>"
        "-D${proj}_INCLUDE_DIR:PATH=${${proj}_INCLUDE_DIR}"
        "-D${proj}_LIBRARY:PATH=${${proj}_LIBRARY}"
        "-D${proj}_RUNTIME_LIBRARY:PATH=${${proj}_RUNTIME_LIBRARY}"
        -P "${CMAKE_CURRENT_LIST_DIR}/${name}.install.cmake")
