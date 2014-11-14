# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (tomviz_version_major 0)
set (tomviz_version_minor 4)
set (tomviz_version_patch 0)
set (tomviz_version_suffix)
set (tomviz_version "${tomviz_version_major}.${tomviz_version_minor}.${tomviz_version_patch}")

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "tomviz")
set(CPACK_PACKAGE_NAME "tomviz")
set(CPACK_PACKAGE_VENDOR "Kitware")
set(CPACK_PACKAGE_VERSION_MAJOR ${tomviz_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${tomviz_version_minor})
if (tomviz_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${tomviz_version_patch}-${tomviz_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${tomviz_version_patch})
endif()

set(CPACK_RESOURCE_FILE_LICENSE "${TomVizSuperBuild_SOURCE_DIR}/LICENSE")

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")
