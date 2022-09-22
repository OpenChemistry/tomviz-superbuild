set(VTK_SMP_IMPLEMENTATION_TYPE "Sequential")
if (tbb_ENABLED)
  set(VTK_SMP_IMPLEMENTATION_TYPE "TBB")
endif ()

set(paraview_extra_cmake_args)
if (QT_HELP_GENERATOR)
  list(APPEND paraview_extra_cmake_args
    -DQT_HELP_GENERATOR:FILEPATH=${QT_HELP_GENERATOR})
else()
  list(APPEND paraview_extra_cmake_args
    -DPARAVIEW_ENABLE_EMBEDDED_DOCUMENTATION:BOOL=OFF)
endif()
if (QT_XMLPATTERNS_EXECUTABLE)
  list(APPEND paraview_extra_cmake_args
    -DQT_XMLPATTERNS_EXECUTABLE:FILEPATH=${QT_XMLPATTERNS_EXECUTABLE})
endif()

add_external_project(paraview
  DEPENDS qt python ffmpeg pygments holoplay
  DEPENDS_OPTIONAL tbb png

  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DPARAVIEW_BUILD_QT_GUI:BOOL=ON
    -DPARAVIEW_ENABLE_QT_SUPPORT:BOOL=ON
    -DPARAVIEW_BUILD_SHARED_LIBS:BOOL=ON
    -DPARAVIEW_BUILD_TESTING:BOOL=OFF
    -DVTK_PYTHON_FULL_THREADSAFE:BOOL=ON
    -DVTK_NO_PYTHON_THREADS:BOOL=OFF
    -DVTK_PYTHON_VERSION:STRING=3
    -DPARAVIEW_USE_PYTHON:BOOL=ON
    -DPARAVIEW_ENABLE_COMMANDLINE_TOOLS:BOOL=OFF
    -DPARAVIEW_ENABLE_WEB:BOOL=ON
    -DPARAVIEW_USE_QTHELP:BOOL=OFF
    -DPARAVIEW_USE_VTKM:BOOL=OFF
    -DPARAVIEW_PLUGINS_DEFAULT:BOOL=OFF
    # Disable for now as kits requires CMake 3.12
    #    -DPARAVIEW_ENABLE_KITS:BOOL=ON
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=ON
    -DCMAKE_CXX_STANDARD:STRING=11
    -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=ON
    -DPARAVIEW_ENABLE_LOOKINGGLASS:BOOL=ON
    -DPARAVIEW_PLUGIN_ENABLE_LookingGlass:BOOL=ON
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=${VTK_SMP_IMPLEMENTATION_TYPE}
    -DHoloPlayCore_INCLUDE_DIR:PATH=${HoloPlayCore_INCLUDE_DIR}
    -DHoloPlayCore_LIBRARY:PATH=${HoloPlayCore_LIBRARY}

    ${paraview_extra_cmake_args}

    # Specify the apple app install prefix. No harm in specifying it for all
    # platforms but will only affect macOS, same with install name dir.
    -DMACOSX_APP_INSTALL_PREFIX:PATH=<INSTALL_DIR>/Applications
    -DCMAKE_INSTALL_NAME_DIR=<INSTALL_DIR>/lib

  LIST_SEPARATOR +
)
