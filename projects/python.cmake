
add_external_project_or_use_system(python
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-unicode=ucs4
                    --enable-shared
  PROCESS_ENVIRONMENT CFLAGS -I${CMAKE_OSX_SYSROOT}/usr/include
  )
set (pv_python_executable "${install_location}/bin/python3" CACHE INTERNAL "" FORCE)
