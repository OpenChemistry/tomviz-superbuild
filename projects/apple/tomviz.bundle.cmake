include(tomviz.bundle.common)

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
         \"${install_location}/lib/python2.7/site-packages/\")

    if(${itk_ENABLED})
        message(\"Installing ITK\")
        file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Libraries\"
             USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
             \"${install_location}/lib/itk/\")
    endif()

    # at this point, the installed bundle should have the libraries that need to
    # be 'fixed' using otool.
    execute_process(
       COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
               \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app\"
               \"${install_location}/lib\"
               \"${install_location}/plugins\")
   "
   COMPONENT superbuild)

add_test(GenerateTomVizPackage
        ${CMAKE_CPACK_COMMAND} -G DragNDrop -V
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomVizPackage
                     PROPERTIES
                     TIMEOUT 3600)
