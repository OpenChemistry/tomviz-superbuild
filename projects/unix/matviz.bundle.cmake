include(matviz.bundle.common)
include(CPack)


# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview-4.1"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install all matviz libraries
install(DIRECTORY "${install_location}/lib/matviz-${matviz_version}"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

if (qt_ENABLED AND NOT USE_SYSmatviz_qt)
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to
    # avoid the need for plugins.
    "${install_location}/plugins/"
    DESTINATION "lib/matviz-${matviz_version}"
    COMPONENT superbuild
    PATTERN "*.a" EXCLUDE
    PATTERN "matviz-${matviz_version}" EXCLUDE
    PATTERN "fontconfig" EXCLUDE
    PATTERN "*.jar" EXCLUDE
    PATTERN "*.debug.*" EXCLUDE
    PATTERN "libboost*" EXCLUDE)
endif()

# install executables
foreach(executable matviz)
  install(PROGRAMS "${install_location}/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()
