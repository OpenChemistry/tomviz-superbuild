add_external_project(matvis
  DEPENDS paraview qt

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -DPYTHONQT_DIR:PATH=<INSTALL_DIR>
)
