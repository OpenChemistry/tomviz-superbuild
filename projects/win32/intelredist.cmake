add_external_project(intelredist
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_dir:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/intelredist.install.cmake")
