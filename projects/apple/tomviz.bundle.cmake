include(tomviz.bundle.common)

# Make the DragNDrop installer look pretty.
set(CPACK_DMG_BACKGROUND_IMAGE
  "${CMAKE_CURRENT_LIST_DIR}/files/CMakeDMGBackground.tif")
set(CPACK_DMG_DS_STORE_SETUP_SCRIPT
  "${CMAKE_CURRENT_LIST_DIR}/files/CMakeDMGSetup.scpt")

set(CPACK_GENERATOR DragNDrop)
include(CPack)

set(superbuild_install_location ${install_location})
include(SuperbuildInstallMacros)

superbuild_apple_create_app(
  "\${CMAKE_INSTALL_PREFIX}"
  "tomviz.app"
  "${superbuild_install_location}/Applications/tomviz.app/Contents/MacOS/tomviz"
  CLEAN
  SEARCH_DIRECTORIES "${superbuild_install_location}/lib" "${Qt5_DIR}/../../../lib" "${Qt5_DIR}/../../../plugins"
  INCLUDE_REGEXES ".*/libgfortran" ".*/libquadmath")

install(
  FILES       "${superbuild_install_location}/Applications/tomviz.app/Contents/Resources/tomviz.icns"
  DESTINATION "tomviz.app/Contents/Resources"
  COMPONENT   superbuild)
install(
  FILES       "${superbuild_install_location}/Applications/tomviz.app/Contents/Info.plist"
  DESTINATION "tomviz.app/Contents"
  COMPONENT   superbuild)

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf" "[Paths]\nPlugins = Plugins\n")
install(
  FILES       "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
  DESTINATION "tomviz.app/Contents/Resources"
  COMPONENT   superbuild)

install(
  DIRECTORY "${superbuild_install_location}/Applications/tomviz.app/Contents/share"
  DESTINATION "tomviz.app/Contents"
  COMPONENT superbuild)

# Install the core python modules we got when building python itself (this skips site-packages
# since that is covered later.
install(
  DIRECTORY "${superbuild_install_location}/lib/python3.6/"
  DESTINATION "tomviz.app/Contents/Python"
  COMPONENT superbuild
  PATTERN "site-packages/*" EXCLUDE
  PATTERN "*.pyc" EXCLUDE)

# ITK doesn't set up rpaths in its python modules even though it has @rpath in where to find
# the libraries.  So we need to strip the rpaths (until we fix ITK to put rpaths in the python
# modules).
install(CODE
  "execute_process(
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_itk.py \"${superbuild_install_location}/lib/itk\")"
  COMPONENT superbuild)

# ITK dumps a bunch of stuff in the root site_packages directory.  I've factored this list out
# into its own file since it is huge.  This will need changing if we enable more of ITK.
# This include brings in one variable: itk_python_modules which is a list of all the root ITK
# python modules.
include(itk_list)

superbuild_apple_install_python(
  "\${CMAKE_INSTALL_PREFIX}"
  "tomviz.app"
  MODULES tomviz
          paraview
          pygments
	  vtk
	  vtkmodules
          ${itk_python_modules}
          pyfftw
          numpy
          scipy
          pyfftw
  MODULE_DIRECTORIES
	  "${superbuild_install_location}/Applications/paraview.app/Contents/Python"
	  "${superbuild_install_location}/Applications/tomviz.app/Contents/Python"
	  "${superbuild_install_location}/lib/python3.6/site-packages"
	  "${superbuild_install_location}/lib/itk/python3.6/site-packages"
  SEARCH_DIRECTORIES
	  "${superbuild_install_location}/Applications/paraview.app/Contents/Libraries"
	  "${superbuild_install_location}/lib")

# This directory is not a python module (no __init__.py) so it is skipped by the packaging script
# as not important (junk like numpy's headers).  However, ITK's python interface is completely broken
# without it.
install(DIRECTORY "${superbuild_install_location}/lib/itk/python3.6/site-packages/itk/Configuration"
  DESTINATION "tomviz.app/Contents/Python/itk/"
  COMPONENT superbuild)

file(GLOB qt5_plugin_paths
 "${Qt5_DIR}/../../../plugins/platforms/*.dylib"
 "${Qt5_DIR}/../../../plugins/printsupport/*.dylib")
foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_apple_install_module(
    "\${CMAKE_INSTALL_PREFIX}"
    "tomviz.app"
    "${qt5_plugin_path}"
    "Contents/Plugins/${qt5_plugin_group}"
    SEARCH_DIRECTORIES  "${library_paths}")
endforeach ()

add_test(GenerateTomvizPackage
        ${CMAKE_CPACK_COMMAND} -G DragNDrop
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomvizPackage
                     PROPERTIES
                     TIMEOUT 3600)
