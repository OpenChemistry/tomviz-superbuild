add_external_project(tomviz
  DEPENDS paraview qt

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -Dtomviz_data_DIR:PATH=${tomviz_data}

  ENABLED_DEFAULT ON
)
