# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Tomviz")
set(CPACK_PACKAGE_NAME "Tomviz")
set(CPACK_PACKAGE_VENDOR "Kitware")
set(CPACK_PACKAGE_VERSION_MAJOR ${tomviz_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${tomviz_version_minor})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "tomviz")
if (tomviz_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${tomviz_version_patch}-${tomviz_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${tomviz_version_patch})
endif()

set(CPACK_RESOURCE_FILE_LICENSE "${TomvizSuperbuild_SOURCE_DIR}/LICENSE")

set(CPACK_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")
