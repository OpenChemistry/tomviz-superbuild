set(proj HoloPlayCore)
set(name holoplay)

if (WIN32)
  file(INSTALL ${${proj}_RUNTIME_LIBRARY}
    DESTINATION "${install_dir}/bin/")
endif ()
