include(tomviz.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview-5.0"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(DIRECTORY "${install_location}/lib/python2.7"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

install(CODE
  "
  file(GLOB shared_libs \"${install_location}/lib/*.so\")
  message(\"\${CMAKE_INSTALL_PREFIX}/lib\")
  foreach( lib \${shared_libs})
    if (IS_SYMLINK ${lib})
      get_filename_component(resolved_link "${lib}" REALPATH)
      set(${lib} ${resolved_link})
    endif()
    message(\${lib})
    file(INSTALL \${lib}
      DESTINATION \"\${CMAKE_INSTALL_PREFIX}/lib\"
      USE_SOURCE_PERMISSIONS)
  endforeach()
  " 
  COMPONENT superbuild)

install(DIRECTORY "${install_location}/share"
  DESTINATION "share"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

if (qt_ENABLED AND NOT USE_SYSTEM_qt)
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to
    # avoid the need for plugins.
    "${install_location}/plugins/"
    DESTINATION "lib/tomviz"
    COMPONENT superbuild
    PATTERN "*.a" EXCLUDE
    PATTERN "tomviz-${tomviz_version}" EXCLUDE
    PATTERN "fontconfig" EXCLUDE
    PATTERN "*.jar" EXCLUDE
    PATTERN "*.debug.*" EXCLUDE
    PATTERN "libboost*" EXCLUDE)
endif()

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

add_test(GenerateTomVizPackage
        ${CMAKE_CPACK_COMMAND} -G TGZ -V
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomVizPackage
                     PROPERTIES
                     TIMEOUT 3600)
