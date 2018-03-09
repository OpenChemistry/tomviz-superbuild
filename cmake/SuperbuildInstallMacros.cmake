set(_superbuild_install_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")
set_property(GLOBAL PROPERTY
  superbuild_has_cleaned FALSE)

include(CMakeParseArguments)

if (NOT superbuild_python_executable)
  find_package(PythonInterp 2.7)
  if (PYTHONINTERP_FOUND)
    set(superbuild_python_executable
      "${PYTHON_EXECUTABLE}")
  else ()
    message(FATAL_ERROR
      "Could not find a Python executable newer than 2.7; one is required "
      "to create packages on Linux and Windows.")
  endif ()
endif ()

# =======================================================================
# OS X
# =======================================================================

# Create an application bundle.
#
# Usage:
#
#   superbuild_apple_create_app(<destination> <name> <binary>
#     [INCLUDE_REGEXES <regex>...]
#     [EXCLUDE_REGEXES <regex>...]
#     [SEARCH_DIRECTORIES <library-path>...]
#     [PLUGINS <plugin>...]
#     [FAKE_PLUGIN_PATHS] [CLEAN])
#
# Creates a ``<name>.app`` bundle. The bundle is placed in ``<destination>``
# with ``<binary>`` (full path) as a main executable for the bundle (under the
# ``MacOS/`` directory). Libraries are searched for and placed into the bundle
# from the ``<library-paths>`` specified. Library IDs and link paths are
# rewritten to use ``@executable_path`` or ``@loader_path`` as necessary.
#
# To exclude libraries from the bundle, use Python regular expressions as
# arguments to the ``EXCLUDE_REGEXES`` keyword. To include any
# otherwise-excluded libraries, use ``INCLUDE_REGEXES``. System libraries and
# frameworks are excluded by default.
#
# The ``CLEAN`` argument starts a new bundle, otherwise the bundle is left
# as-is (and is expected to have been created by this call).
#
# Plugins may be listed under the ``PLUGINS`` keyword and will be installed to
# the ``Plugins/`` directory in the bundle. These are full paths to the plugin
# binaries. If ``FAKE_PLUGIN_PATHS`` is given, the plugin is treated as its
# own ``@executable_path`` which is useful when packaging plugins which may be
# used for multiple applications and may require additional libraries
# depending on the application.
function (superbuild_apple_create_app destination name binary)
  set(options
    CLEAN
    FAKE_PLUGIN_PATHS)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES
    PLUGINS)
  cmake_parse_arguments(_create_app "${options}" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  if (_create_app_CLEAN)
    if (superbuild_is_install_target)
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --new")
    else ()
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --clean --new")
    endif ()
  endif ()

  if (_create_app_FAKE_PLUGIN_PATHS)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --fake-plugin-paths")
  endif ()

  foreach (include_regex IN LISTS _create_app_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _create_app_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _create_app_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  foreach (plugin IN LISTS _create_app_PLUGINS)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --plugin \"${plugin}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --type        executable
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

# Add a utility executable to a bundle.
#
# Usage:
#
#   superbuild_apple_install_utility(<destination> <name> <binary>
#     [INCLUDE_REGEXES <regex>...]
#     [EXCLUDE_REGEXES <regex>...]
#     [SEARCH_DIRECTORIES <library-path>...])
#
# Adds a binary to the ``bin/`` path of the bundle. Required libraries are
# installed and fixed up.
#
# Must match an existing call to ``superbuild_apple_create_app(<destination>
# <name>)``.
#
# See ``superbuild_apple_create_app`` for the documentation for
# ``INCLUDE_REGEXES``, ``EXCLUDE_REGEXES``, and ``SEARCH_DIRECTORIES``.
function (superbuild_apple_install_utility destination name binary)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_utility "" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  foreach (include_regex IN LISTS _install_utility_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_utility_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_utility_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --type        utility
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

# Add a module library to a bundle.
#
# Usage:
#
#   superbuild_apple_install_module(<destination> <name> <binary> <location>
#     [INCLUDE_REGEXES <regex>...]
#     [EXCLUDE_REGEXES <regex>...]
#     [SEARCH_DIRECTORIES <library-path>...])
#
# Adds a library to the ``<location>`` path of the bundle. Required libraries are
# installed and fixed up using ``@loader_path``. Use this to install things
# such as compiled language modules and the like.
#
# Must match an existing call to ``superbuild_apple_create_app(<destination>
# <name>)``.
#
# See ``superbuild_apple_create_app`` for the documentation for
# ``INCLUDE_REGEXES``, ``EXCLUDE_REGEXES``, and ``SEARCH_DIRECTORIES``.
function (superbuild_apple_install_module destination name binary location)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_module "" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  foreach (include_regex IN LISTS _install_module_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_module_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_module_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --location    \"${location}\"
              --type        module
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

# Add Python modules or packages to a bundle.
#
# Usage:
#
#   superbuild_apple_install_python(<destination> <name>
#     MODULES <module>...
#     MODULE_DIRECTORIES <module-path>...
#     [SEARCH_DIRECTORIES <library-path>...])
#
# Adds Python modules or packages ``<modules>`` to the bundle. Required
# libraries are searched for in the ``<library-paths>`` and placed next to the
# module which requires it.
#
# See ``superbuild_unix_install_python`` for the documentation for
# ``MODULES`` and ``MODULE_DIRECTORIES``.
function (superbuild_apple_install_python destination name)
  set(multivalues
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "" "" "${multivalues}" ${ARGN})

  if (NOT _install_python_MODULES)
    message(FATAL_ERROR "No modules specified.")
  endif ()

  if (NOT _install_python_MODULE_DIRECTORIES)
    message(FATAL_ERROR "No modules search paths specified.")
  endif ()

  set(fixup_bundle_arguments)

  foreach (search_directory IN LISTS _install_python_SEARCH_DIRECTORIES)
    list(APPEND fixup_bundle_arguments
      --search "${search_directory}")
  endforeach ()

  install(CODE
    "include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.apple.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")

    set(fixup_bundle_arguments \"${fixup_bundle_arguments}\")
    set(bundle_destination \"${destination}\")
    set(bundle_name \"${name}\")
    set(bundle_manifest \"${CMAKE_BINARY_DIR}/${name}.manifest\")

    foreach (python_module IN LISTS python_modules)
      superbuild_apple_install_python_module(\"\${bundle_destination}/\${bundle_name}\"
        \"\${python_module}\" \"\${module_directories}\" \"Contents/Python\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()
