# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (tem_version_major 1)
set (tem_version_minor 0)
set (tem_version_patch 5)
set (tem_version_suffix)
set (tem_version "${tem_version_major}.${tem_version_minor}.${tem_version_patch}")

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "VeloView")
set(CPACK_PACKAGE_NAME "VeloView")
set(CPACK_PACKAGE_VENDOR "Velodyne Lidar")
set(CPACK_PACKAGE_VERSION_MAJOR ${tem_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${tem_version_minor})
if (tem_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${tem_version_patch}-${tem_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${tem_version_patch})
endif()

set(CPACK_RESOURCE_FILE_LICENSE "${VelodyneViewerSuperBuild_SOURCE_DIR}/LICENSE")

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")
