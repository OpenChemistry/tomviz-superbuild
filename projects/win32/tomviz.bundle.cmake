include(tomviz.bundle.common)

#------------------------------------------------------------------------------
# set NSIS install specific stuff.

set (CPACK_NSIS_MENU_LINKS
  "bin/tomviz.exe" "tomviz")

set(CPACK_PACKAGE_EXECUTABLES "tomviz" "tomviz" ${CPACK_PACKAGE_EXECUTABLES})
set(CPACK_CREATE_DESKTOP_LINKS "tomviz" ${CPACK_CREATE_DESKTOP_LINKS})
set(CPACK_NSIS_MODIFY_PATH OFF)

set(AppName tomviz)

install(DIRECTORY "${install_location}/bin/"
        DESTINATION "bin"
        COMPONENT ${AppName})

install(DIRECTORY "${install_location}/share/"
        DESTINATION "share"
        COMPONENT ${AppName})

# install python since (since python dlls are not in the install location)
if (python_ENABLED AND NOT USE_SYSTEM_python)
  # install the Python's modules.
  install(DIRECTORY "${SuperBuild_BINARY_DIR}/python/src/python/Lib"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ${AppName})

  # install python dlls.
  get_filename_component(python_bin_dir "${pv_python_executable}" PATH)
  install(DIRECTORY "${python_bin_dir}/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ${AppName}
          FILES_MATCHING PATTERN "python*.dll")
endif()

# install paraview python modules and others.
install(DIRECTORY "${install_location}/lib/paraview-4.3"
        DESTINATION "lib"
        USE_SOURCE_PERMISSIONS
        COMPONENT ${AppName}
        PATTERN "*.lib" EXCLUDE)

# install tomviz Python modules and others
install(DIRECTORY "${install_location}/lib/tomviz-${tomviz_version}"
        DESTINATION "lib"
        USE_SOURCE_PERMISSIONS
        COMPONENT ${AppName}
        PATTERN "*.lib" EXCLUDE)

#------------------------------------------------------------------------------
set (CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/InstallerIcon.ico")

if (64bit_build)
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif()

# install system runtimes.
set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
include(InstallRequiredSystemLibraries)
include(CPack)

add_test(GenerateTomVizPackage-NSIS
        ${CMAKE_CPACK_COMMAND} -G NSIS -V
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

add_test(GenerateTomVizPackage-ZIP
        ${CMAKE_CPACK_COMMAND} -G ZIP -V
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomVizPackage-NSIS
                     GenerateTomVizPackage-ZIP
                     PROPERTIES
                     TIMEOUT 1200)
