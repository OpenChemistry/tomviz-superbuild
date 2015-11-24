set(fftw_targets fftw3double fftw3float fftw3long)
if (WIN32)
  set(fftw_targets fftw)
endif()
add_external_project(itk
  DEPENDS ${fftw_targets}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_dir:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/itk.install.cmake")
