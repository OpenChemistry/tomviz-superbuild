set(tomviz_extra_cmake_args)
if (UNIX AND NOT APPLE)
  list(APPEND tomviz_extra_cmake_args
    -DCMAKE_INSTALL_RPATH:STRING=$ORIGIN/../lib:$ORIGIN/../lib/paraview-5.0:$ORIGIN/../lib/itk
  )
endif()
add_external_project(tomviz
  DEPENDS paraview qt

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -Dtomviz_data_DIR:PATH=${tomviz_data}
    ${tomviz_extra_cmake_args}

  ENABLED_DEFAULT ON
)
