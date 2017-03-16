include(tomviz.bundle.common)

# Make the DragNDrop installer look pretty.
set(CPACK_DMG_BACKGROUND_IMAGE
  "${CMAKE_CURRENT_LIST_DIR}/files/CMakeDMGBackground.tif")
set(CPACK_DMG_DS_STORE_SETUP_SCRIPT
  "${CMAKE_CURRENT_LIST_DIR}/files/CMakeDMGSetup.scpt")

set(CPACK_GENERATOR DragNDrop)
include(CPack)

install(CODE "
    cmake_policy(VERSION 2.8.8)
    # Install the app first.
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}\" USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/Applications/tomviz.app\")
    file(WRITE \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Resources/qt.conf\"
               \"\")

    # install all python modules/packages from paraview.
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Python/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/Applications/paraview.app/Contents/Python/\")

    # install all other libraries from paraview (this is needed for the PythonD-*.dylib files
    # which don't get copied over by the fixup_bundle.py)
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Libraries/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/Applications/paraview.app/Contents/Libraries/\")

    # install all python modules/packages for numpy and pyfftw.
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Python/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/lib/python3.6/site-packages/\")

    if(${itk_ENABLED})
        execute_process(
          COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_itk.py
                  \"${install_location}/lib/itk\")
        message(\"Installing ITK\")
        file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Python/\"
             USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
             \"${install_location}/lib/itk/python3.6/site-packages/\")
    endif()

    # at this point, the installed bundle should have the libraries that need to
    # be 'fixed' using otool.
    # qt/plugins is needed as QtPrintSupport.framework directly links to the printsupport plugin
    execute_process(
       COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
               --exe \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app\"
               --search \"${install_location}/lib\"
               --search \"${Qt5_DIR}/../../../lib\"
               --search \"${Qt5_DIR}/../../../plugins\"
               --plugins \"${Qt5_DIR}/../../../plugins\")
   "
   COMPONENT superbuild)

add_test(GenerateTomvizPackage
        ${CMAKE_CPACK_COMMAND} -G DragNDrop
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomvizPackage
                     PROPERTIES
                     TIMEOUT 3600)
