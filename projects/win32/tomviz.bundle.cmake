include(tomviz.bundle.common)

# CPack WiX support needs the license file to end in .txt inorder to automatically
# convert to RTF for us
install(CODE
  "execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${TomvizSuperbuild_SOURCE_DIR}/LICENSE ${TomvizSuperbuild_BINARY_DIR}/LICENSE.txt )"
  COMPONENT superbuild)

configure_file("${TomvizSuperbuild_SOURCE_DIR}/projects/win32/cpack_config_file.cmake.in"
  "${TomvizSuperbuild_BINARY_DIR}/cpack_config_file.cmake" @ONLY)

set(CPACK_PROJECT_CONFIG_FILE "${TomvizSuperbuild_BINARY_DIR}/cpack_config_file.cmake")

set(CPACK_PACKAGE_EXECUTABLES "tomviz" "tomviz" ${CPACK_PACKAGE_EXECUTABLES})
set(CPACK_CREATE_DESKTOP_LINKS "tomviz" ${CPACK_CREATE_DESKTOP_LINKS})

set(AppName tomviz)

install(DIRECTORY "${install_location}/bin/"
        DESTINATION "bin"
        COMPONENT ${AppName})

install(DIRECTORY "${install_location}/share/"
        DESTINATION "share"
        COMPONENT ${AppName})

# install paraview python modules and others.
install(DIRECTORY "${install_location}/lib"
        DESTINATION "lib"
        USE_SOURCE_PERMISSIONS
        COMPONENT ${AppName}
        PATTERN "*.lib" EXCLUDE
        PATTERN "*.a" EXCLUDE)

# install system runtimes.
set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
include(InstallRequiredSystemLibraries)
include(CPack)

# Build WIX package
add_test(GenerateTomvizPackage-WIX
        ${CMAKE_CPACK_COMMAND} -G WIX
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

# Build zip
add_test(GenerateTomvizPackage-ZIP
        ${CMAKE_CPACK_COMMAND} -G ZIP
        WORKING_DIRECTORY ${Superbuild_BINARY_DIR})

set_tests_properties(GenerateTomvizPackage-ZIP
                     GenerateTomvizPackage-WIX
                     PROPERTIES
                     TIMEOUT 1200)
