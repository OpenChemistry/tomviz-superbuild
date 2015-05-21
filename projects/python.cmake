if (APPLE)
  message(FATAL_ERROR "ABORT")
endif()

add_external_project_or_use_system(python
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-unicode=ucs4
                    --enable-shared
  )
set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)
