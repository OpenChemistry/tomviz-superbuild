find_package(Qt5 REQUIRED
  COMPONENTS
    Core)

add_external_dummy_project(qt)

add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=5
  -DQt5_DIR:PATH=${Qt5_DIR}
  -DQt5Core_DIR:PATH=${Qt5_DIR}/../Qt5Core
  -DQt5Help_DIR:PATH=${Qt5_DIR}/../Qt5Help
  -DQt5Network_DIR:PATH=${Qt5_DIR}/../Qt5Network
  -DQt5Test_DIR:PATH=${Qt5_DIR}/../Qt5Test
  -DQt5UiTools_DIR:PATH=${Qt5_DIR}/../Qt5UiTools
)
