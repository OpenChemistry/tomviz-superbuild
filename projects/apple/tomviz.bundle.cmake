include(tomviz.bundle.common)

set(CPACK_GENERATOR DragNDrop)
include(CPack)

install(CODE "
     file(INSTALL DESTINATION \"\${CMAKE_INSTALL_PREFIX}\" USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
          \"${install_location}/Applications/TomViz.app\")

     file(WRITE \"\${CMAKE_INSTALL_PREFIX}/TomViz.app/Contents/Resources/qt.conf\"
                \"\")
     execute_process(
       COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
               \"\${CMAKE_INSTALL_PREFIX}/TomViz.app\"
               \"${install_location}/lib\"
               \"${install_location}/plugins\")
   "
   COMPONENT superbuild)
