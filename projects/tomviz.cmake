set(tomviz_extra_cmake_args)
if (UNIX AND NOT APPLE)
  list(APPEND tomviz_extra_cmake_args
    -DCMAKE_INSTALL_RPATH:STRING=$ORIGIN/../lib:$ORIGIN/../lib/paraview:$ORIGIN/../lib/itk
  )
endif()
if (QT_HELP_GENERATOR)
  list(APPEND tomviz_extra_cmake_args
    -DQT_HELP_GENERATOR:FILEPATH=${QT_HELP_GENERATOR})
endif()
if (QT_XMLPATTERNS_EXECUTABLE)
  list(APPEND tomviz_extra_cmake_args
    -DQT_XMLPATTERNS_EXECUTABLE:FILEPATH=${QT_XMLPATTERNS_EXECUTABLE})
endif()
if (UNIX)
  list(APPEND tomviz_extra_cmake_args
    -DPYBIND11_PYTHON_VERSION:STRING=3.7)
endif()

# The new fixup bundle correctly handles RPATHs... if the binary/module has them correctly set
if (APPLE)
  list(APPEND tomviz_extra_cmake_args
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON)
endif()

add_external_project(tomviz
  DEPENDS paraview qt

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -Dtomviz_data_DIR:PATH=${tomviz_data}
    -DTOMVIZ_DOWNLOAD_WEB:BOOL=ON
    -DSKIP_PARAVIEW_ITK_PYTHON_CHECKS:BOOL=ON
    -DHoloPlayCore_INCLUDE_DIR:PATH=${HoloPlayCore_INCLUDE_DIR}
    -DHoloPlayCore_LIBRARY:PATH=${HoloPlayCore_LIBRARY}

    ${tomviz_extra_cmake_args}

  ENABLED_DEFAULT ON
)
