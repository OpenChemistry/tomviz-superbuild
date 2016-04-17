include(tomviz.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(DIRECTORY "${install_location}/lib/python2.7"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)
install(DIRECTORY "${install_location}/include/python2.7"
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
      -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)"
  COMPONENT superbuild)

if (qt_ENABLED)
  set(qt_plugins)
  if (NOT USE_SYSTEM_qt)
    file(GLOB qt_plugins ${install_location}/plugins/*)
  else()
    file(GLOB qt_plugins ${Qt5_DIR}/../../../plugins/*)
  endif()
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
  if (NOT USE_SYSTEM_qt)
    install(DIRECTORY
      # install all qt plugins (including sqllite).
      "${install_location}/plugins/"
      DESTINATION ""
      COMPONENT superbuild
      PATTERN "*.a" EXCLUDE
      PATTERN "tomviz-${tomviz_version}" EXCLUDE
      PATTERN "fontconfig" EXCLUDE
      PATTERN "*.jar" EXCLUDE
      PATTERN "*.debug.*" EXCLUDE
      PATTERN "libboost*" EXCLUDE)
    install(DIRECTORY "${install_location}/share/appdata"
      DESTINATION "share"
      USE_SOURCE_PERMISSIONS
      COMPONENT superbuild)
    install(DIRECTORY "${install_location}/share/applications"
      DESTINATION "share"
      USE_SOURCE_PERMISSIONS
      COMPONENT superbuild)
    install(DIRECTORY "${install_location}/share/icons"
      DESTINATION "share"
      USE_SOURCE_PERMISSIONS
      COMPONENT superbuild)
  endif()
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
install(DIRECTORY "${install_location}/lib/itk"
        DESTINATION "lib"
	USE_SOURCE_PERMISSIONS
	COMPONENT superbuild)
endif()

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
