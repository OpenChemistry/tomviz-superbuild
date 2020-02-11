set(process_environment)
if (UNIX AND NOT APPLE)
  set (process_environment PROCESS_ENVIRONMENT
    LD_LIBRARY_PATH "<INSTALL_DIR>/lib")
endif()

set(extra_install_args
     )

add_external_project(marshmallow
  DEPENDS python
  ENABLED_DEFAULT ON
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND
    ${install_command_env}
    ${pv_python_executable} setup.py install
      --single-version-externally-managed --root=/
      ${process_environment}
)
