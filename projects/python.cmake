add_external_project_or_use_system(python
  DEPENDS zlib
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-unicode=ucs4
                    --enable-shared
  )
set (pv_python_executable "${install_location}/bin/python3" CACHE INTERNAL "" FORCE)

add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python3
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python3.6m
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython3.6m.dylib
  -DVTK_PYTHON_VERSION:STRING=3)
