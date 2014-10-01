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

  # install python pyd objects (python dlls).
  # For 64 bit builds, these are in an amd64/ subdir
  set(PYTHON_PCBUILD_SUBDIR "")
  if(CMAKE_CL_64)
    set(PYTHON_PCBUILD_SUBDIR "amd64/")
  endif()
  install(DIRECTORY "${SuperBuild_BINARY_DIR}/python/src/python/PCbuild/${PYTHON_PCBUILD_SUBDIR}"
          DESTINATION "bin/Lib"
          USE_SOURCE_PERMISSIONS
          COMPONENT ${AppName}
          FILES_MATCHING PATTERN "*.pyd")
endif()

# install paraview python modules and others.
install(DIRECTORY "${install_location}/lib/paraview-4.2"
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

# install all extra Python modules/packages.
if (numpy_ENABLED)
  # on Windows, all Python packages simply go under bin/Lib/site-packages"
  install(DIRECTORY "${install_location}/lib/site-packages/"
    DESTINATION "bin/Lib/site-packages"
    USE_SOURCE_PERMISSIONS
    COMPONENT ${AppName})
endif()

#------------------------------------------------------------------------------
set (CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/InstallerIcon.ico")

if (64bit_build)
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif()


# install system runtimes.
set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
include(InstallRequiredSystemLibraries)
include(CPack)



