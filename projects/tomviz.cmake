set(tomviz_extra_cmake_args)
if (UNIX AND NOT APPLE)
  list(APPEND tomviz_extra_cmake_args
    -DCMAKE_INSTALL_RPATH:STRING=$ORIGIN/../lib:$ORIGIN/../lib/paraview:$ORIGIN/../lib/itk
  )
endif()
if (QT_XMLPATTERNS_EXECUTABLE)
  list(APPEND tomviz_extra_cmake_args
    -DQT_XMLPATTERNS_EXECUTABLE:FILEPATH=${QT_XMLPATTERNS_EXECUTABLE})
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
