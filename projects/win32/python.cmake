add_external_project(python
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_dir:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/python.install.cmake")

add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python.exe
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/bin/Include
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/bin/libs/python36.lib
  -DVTK_PYTHON_VERSION:STRING=3)
