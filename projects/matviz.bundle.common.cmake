# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (matviz_version_major 1)
set (matviz_version_minor 0)
set (matviz_version_patch 0)
set (matviz_version_suffix)
set (matviz_version "${matviz_version_major}.${matviz_version_minor}.${matviz_version_patch}")

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "matviz")
set(CPACK_PACKAGE_NAME "MatViz")
set(CPACK_PACKAGE_VENDOR "MatViz")
set(CPACK_PACKAGE_VERSION_MAJOR ${matviz_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${matviz_version_minor})
if (matviz_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${matviz_version_patch}-${matviz_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${matviz_version_patch})
endif()

set(CPACK_RESOURCE_FILE_LICENSE "${MatVizSuperBuild_SOURCE_DIR}/LICENSE")

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")
