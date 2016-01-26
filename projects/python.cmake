if (APPLE)
  message(FATAL_ERROR "ABORT")
endif()

add_external_project_or_use_system(python
  DEPENDS zlib

  CMAKE_ARGS
    -DBUILD_SHARED:BOOL=TRUE
    -DBUILD_STATIC:BOOL=FALSE
  )
set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)
