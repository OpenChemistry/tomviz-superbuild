set(lapack_needs_shared_libs OFF)
if(UNIX AND NOT APPLE)
  set(lapack_needs_shared_libs ON)
endif()

add_external_project_or_use_system(lapack
  BUILD_IN_SOURCE 0
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${lapack_needs_shared_libs}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
    -DCMAKE_Fortran_FLAGS:STRING=-fPIC
  BUILD_COMMAND
    make
  INSTALL_COMMAND
    make install
)
