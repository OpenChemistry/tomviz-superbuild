include(tomviz.bundle.common)

set(CPACK_GENERATOR DragNDrop)
include(CPack)

install(CODE "
     file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}\" USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
          \"${install_location}/Applications/tomviz.app\")

     file(WRITE \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Resources/qt.conf\"
                \"\")

    # install all python modules/packages for numpy and pyfftw.
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Python/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/lib/python2.7/site-packages/\")

    # install all python modules/packages from paraview.
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Python/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/Applications/paraview.app/Contents/Python/\")

    # install all other libraries from paraview (this is needed for the PythonD-*.dylib files
    # which don't get copied over by the fixup_bundle.py
    file(INSTALL DESTINATION \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app/Contents/Libraries/\"
         USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
         \"${install_location}/Applications/paraview.app/Contents/Libraries/\")

    execute_process(
       COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
               \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/tomviz.app\"
               \"${install_location}/lib\"
               \"${install_location}/plugins\")
   "
   COMPONENT superbuild)
