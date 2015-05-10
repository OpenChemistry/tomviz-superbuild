include(tomviz.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview-4.3"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install all tomviz libraries
install(DIRECTORY "${install_location}/lib/tomviz-${tomviz_version}"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

if (qt_ENABLED AND NOT USE_SYSTEM_qt)
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to
    # avoid the need for plugins.
    "${install_location}/plugins/"
    DESTINATION "lib/tomviz-${tomviz_version}"
    COMPONENT superbuild
    PATTERN "*.a" EXCLUDE
    PATTERN "tomviz-${tomviz_version}" EXCLUDE
    PATTERN "fontconfig" EXCLUDE
    PATTERN "*.jar" EXCLUDE
    PATTERN "*.debug.*" EXCLUDE
    PATTERN "libboost*" EXCLUDE)
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
