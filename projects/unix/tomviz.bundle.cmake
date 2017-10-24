include(tomviz.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(DIRECTORY "${install_location}/lib/python3.6"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)
install(DIRECTORY "${install_location}/include/python3.6m"
  DESTINATION "include"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild
  PATTERN "pyconfig.h")

# install tomviz's python modules
install(DIRECTORY "${install_location}/lib/tomviz"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(DIRECTORY "${install_location}/share/tomviz"
  DESTINATION "share"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(CODE
  "execute_process(COMMAND
    ${CMAKE_COMMAND}
      -Dexecutable:PATH=${install_location}/bin/tomviz
      -Ddependencies_root:PATH=${install_location}
      -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib
      -Dpv_version:STRING=${tomviz_version}
      -Dqt_root=${Qt5_DIR}/../../../
      -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)"
  COMPONENT superbuild)

if (qt_ENABLED)
  file(GLOB qt_plugins ${Qt5_DIR}/../../../plugins/*)
  foreach(plugin ${qt_plugins})
    if(IS_DIRECTORY ${plugin})
      install(DIRECTORY ${plugin}
        DESTINATION "plugins"
        COMPONENT superbuild
        PATTERN "*.a" EXCLUDE
        PATTERN "tomviz-${tomviz_version}" EXCLUDE
        PATTERN "fontconfig" EXCLUDE
        PATTERN "*.jar" EXCLUDE
        PATTERN "*.debug.*" EXCLUDE
        PATTERN "libboost*" EXCLUDE)
    endif()
  endforeach()
  install(CODE
"
file(WRITE \"\${CMAKE_INSTALL_PREFIX}/bin/qt.conf\"
\"[Paths]
Prefix = .
Plugins = ../plugins
\")" COMPONENT superbuild)
endif()

# install dependencies of Qt plugins
install(CODE
  "file(GLOB qt_plugins \"\${CMAKE_INSTALL_PREFIX}/plugins/*/*.so\")
  set(qt_libraries_dir \"${Qt5_DIR}/../../..\")
  foreach(plugin \${qt_plugins})
    execute_process(COMMAND
      ${CMAKE_COMMAND}
        -Dexecutable:PATH=\${plugin}
        -Ddependencies_root:PATH=\${qt_libraries_dir}
        -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib
        -Dpv_version:STRING=${tomviz_version}
        -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)
  endforeach()"
  COMPONENT superbuild)

if(itk_ENABLED)
  install(CODE
"
  execute_process(COMMAND
    ${CMAKE_COMMAND}
    -E copy_directory ${install_location}/lib/itk \${CMAKE_INSTALL_PREFIX}/lib)
"
)
endif()

# install dependencies of python plugin libraries
install(CODE
  "file(GLOB_RECURSE plugin_libs \"${CMAKE_INSTALL_PREFIX}/lib/python3.6/site-packages\" *.so)
  set(qt_libraries_dir \"${Qt5_DIR}/../../..\")
  foreach(lib \${plugin_libs})
    execute_process(COMMAND
      ${CMAKE_COMMAND}
        -Dexecutable:PATH=\${lib}
        -Ddependencies_root:PATH=${install_location}
        -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib
        -Dpv_version:STRING=${tomviz_version}
        -Dqt_root:PATH=${Qt5_DIR}/../../../
        -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)
  endforeach()"
  COMPONENT superbuild)

# install executables
foreach(executable tomviz)
  install(PROGRAMS "${install_location}/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()

add_test(GenerateTomvizPackage
        ${CMAKE_CPACK_COMMAND} -G TGZ
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomvizPackage
                     PROPERTIES
                     TIMEOUT 3600)
