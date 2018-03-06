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

# TODO: The functions in this file should be grouped and made OS-agnostic.
#       Keyword arguments should be used more and be uniform across all
#       platforms.

# =======================================================================
# Linux
# =======================================================================

# INTERNAL
# Install a binary and its required libraries to a location.
#
# _superbuild_unix_install_binary(
#   LIBDIR <libdir>
#   BINARY <path>
#   TYPE <module|executable>
#   [CLEAN]
#   [DESTINATION <destination>]
#   [LOCATION <location>]
#   [INCLUDE_REGEXES <include-regex>...]
#   [EXCLUDE_REGEXES <exclude-regex>...]
#   [LOADER_PATHS <loader-paths>...]
#   [SEARCH_DIRECTORIES <search-directory>...])
function (_superbuild_unix_install_binary)
  set(options
    CLEAN)
  set(values
    DESTINATION
    LIBDIR
    LOCATION
    BINARY
    TYPE)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    LOADER_PATHS
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_binary "${options}" "${values}" "${multivalues}" ${ARGN})

  if (NOT _install_binary_BINARY)
    message(FATAL_ERROR "Cannot install a binary without a path.")
  endif ()

  if (NOT IS_ABSOLUTE "${_install_binary_BINARY}")
    message(FATAL_ERROR "Cannot install a binary without an absolute path (${_install_binary_BINARY}).")
  endif ()

  if (NOT _install_binary_DESTINATION)
    set(_install_binary_DESTINATION
      "\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}")
  endif ()

  if (NOT _install_binary_LIBDIR)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing where to put dependent libraries.")
  endif ()

  if (NOT _install_binary_TYPE)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing its type.")
  endif ()

  if (_install_binary_TYPE STREQUAL "module" AND NOT _install_binary_LOCATION)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} as a module without knowing where to place it.")
  endif ()

  set(fixup_bundle_arguments)
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --destination ${_install_binary_DESTINATION}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --type ${_install_binary_TYPE}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --libdir ${_install_binary_LIBDIR}")

  get_property(superbuild_has_cleaned GLOBAL PROPERTY
    superbuild_has_cleaned)
  if (_install_binary_CLEAN OR NOT superbuild_has_cleaned)
    set_property(GLOBAL PROPERTY
      superbuild_has_cleaned TRUE)
    if (superbuild_is_install_target)
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --new")
    else ()
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --clean --new")
    endif ()
  endif ()

  if (_install_binary_LOCATION)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --location \"${_install_binary_LOCATION}\"")
  endif ()

  foreach (include_regex IN LISTS _install_binary_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_binary_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (loader_path IN LISTS _install_binary_LOADER_PATHS)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --loader-path \"${loader_path}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_binary_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${superbuild_python_executable}\"
              \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.unix.py\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/install.manifest\"
              --source      \"${superbuild_install_location}\"
              \"${_install_binary_BINARY}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (_superbuild_unix_install_executable path libdir)
  _superbuild_unix_install_binary(
    BINARY      "${path}"
    LIBDIR      "${libdir}"
    TYPE        executable
    ${ARGN})
endfunction ()

function (_superbuild_unix_install_module path subdir libdir)
  _superbuild_unix_install_binary(
    BINARY      "${path}"
    LOCATION    "${subdir}"
    LIBDIR      "${libdir}"
    TYPE        module
    ${ARGN})
endfunction ()

# Install a "forward executable" from the installation tree to the package.
#
# Usage:
#
#   superbuild_unix_install_program_fwd(<name> <library-paths>
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [SEARCH_DIRECTORIES <search-directory>...])
#
# Note that this installs a program which was created using the KWSys forward
# executable mechanisms. For "regular" binaries, see
# ``superbuild_unix_install_program``.
#
# Installs a binary named ``<name>`` to the package. The ``<library-paths>`` is
# a list of directories to search for the real binary and its libraries.
# Relative paths are taken to be relative to the install directory. The
# libraries are installed to the subdirectory the actual executable is found
# in.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``SEARCH_DIRECTORIES`` is a list of directories
# to search for dependent libraries.
function (superbuild_unix_install_program_fwd name paths)
  set(found FALSE)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      _superbuild_unix_install_module("${superbuild_install_location}/${path}/${name}" "${path}" "${path}" ${ARGN})
      set(found TRUE)
      break ()
    endif ()
  endforeach ()

  if (NOT found)
    message(FATAL_ERROR "Unable to find the actual executable for ${name}")
  endif ()

  _superbuild_unix_install_executable("${superbuild_install_location}/bin/${name}" "lib")
endfunction ()

# Install a program from the installation tree to the package.
#
# Usage:
#
#   superbuild_unix_install_program(<path> <libdir>
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [SEARCH_DIRECTORIES <search-directory>...])
#
# Installs a program ``<name>`` into ``bin/`` and its dependent libraies into
# ``<libdir>``.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``SEARCH_DIRECTORIES`` is a list of directories
# to search for dependent libraries.
function (superbuild_unix_install_program name libdir)
  _superbuild_unix_install_executable("${name}" "${libdir}" ${ARGN})
endfunction ()

# Install a plugin to the package.
#
# Usage:
#
#   superbuild_unix_install_plugin(<filename> <libdir> <search-paths>
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [LOADER_PATHS <loader-paths>...]
#     [SEARCH_DIRECTORIES <search-directory>...])
#
# Install a plugin from ``<filename>`` to the package. The file is searched for
# in ``<search-paths>`` under the superbuild's install tree. Required libraries
# are installed to ``<libdir>``.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``LOADER_PATHS`` is a list of directories where
# the executable loading the plugin is looking for libraries. These are
# searched for dependencies first. ``SEARCH_DIRECTORIES`` is a list of
# directories to search for dependent libraries.
function (superbuild_unix_install_plugin name libdir paths)
  if (IS_ABSOLUTE "${name}")
    _superbuild_unix_install_module("${name}" "${paths}" "${libdir}" ${ARGN})
    return ()
  endif ()

  set(found FALSE)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      _superbuild_unix_install_module("${superbuild_install_location}/${path}/${name}" "${path}" "${libdir}" ${ARGN})
      set(found TRUE)
      break ()
    endif ()
  endforeach ()

  if (NOT found)
    string(REPLACE ";" ", " paths_list "${paths}")
    message(FATAL_ERROR "Unable to find the ${name} plugin in ${paths_list}")
  endif ()
endfunction ()

# Install Python modules to the package.
#
# Usage:
#
#   superbuild_unix_install_python(
#     MODULES <module>...
#     LIBDIR <libdir>
#     MODULE_DIRECTORIES <module-path>...
#     [MODULE_DESTINATION <destination>]
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [LOADER_PATHS <loader-paths>...]
#     [SEARCH_DIRECTORIES <library-path>...])
#
# Installs Python modules or packages named ``<name>`` into the package. The
# ``LIBDIR`` argument is used to place dependent libraries into the correct
# subdirectory of the package. Libraries are searched for in
# ``<library-paths>`` and relative paths are taken to be relative to the
# superbuild's install directory. The modules are searched for in the
# ``<module-paths>``. Modules are installed into the proper location
# (``lib/python2.7/site-packages``) within the package, but may be placed
# inside of a different directory by using the ``MODULE_DESTINATION`` argument.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``LOADER_PATHS`` is a list of directories where
# the executable loading the Python modules is looking for libraries. These are
# searched for dependencies first. ``SEARCH_DIRECTORIES`` is a list of
# directories to search for dependent libraries.
function (superbuild_unix_install_python)
  set(values
    MODULE_DESTINATION
    LIBDIR)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    LOADER_PATHS
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "${options}" "${values}" "${multivalues}" ${ARGN})

  if (NOT _install_python_LIBDIR)
    message(FATAL_ERROR "Cannot install Python modules without knowing where to put dependent libraries.")
  endif ()

  if (NOT _install_python_MODULES)
    message(FATAL_ERROR "No modules specified.")
  endif ()

  if (NOT _install_python_MODULE_DIRECTORIES)
    message(FATAL_ERROR "No modules search paths specified.")
  endif ()

  set(fixup_bundle_arguments)

  if (NOT _install_python_MODULE_DESTINATION)
    set(_install_python_MODULE_DESTINATION "/site-packages")
  endif ()

  foreach (include_regex IN LISTS _install_python_INCLUDE_REGEXES)
    list(APPEND fixup_bundle_arguments
      --include "${include_regex}")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_python_EXCLUDE_REGEXES)
    list(APPEND fixup_bundle_arguments
      --exclude "${exclude_regex}")
  endforeach ()

  foreach (search_directory IN LISTS _install_python_SEARCH_DIRECTORIES)
    list(APPEND fixup_bundle_arguments
      --search "${search_directory}")
  endforeach ()

  foreach (loader_path IN LISTS _install_python_LOADER_PATHS)
    list(APPEND fixup_bundle_arguments
      --loader-path "${loader_path}")
  endforeach ()

  install(CODE
    "set(superbuild_python_executable \"${superbuild_python_executable}\")
    include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.unix.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")

    set(fixup_bundle_arguments \"${fixup_bundle_arguments}\")
    set(bundle_destination \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}\")
    set(bundle_manifest \"${CMAKE_BINARY_DIR}/install.manifest\")
    set(libdir \"${_install_python_LIBDIR}\")

    foreach (python_module IN LISTS python_modules)
      superbuild_unix_install_python_module(\"\${CMAKE_INSTALL_PREFIX}\"
        \"\${python_module}\" \"\${module_directories}\" \"lib/python2.7${_install_python_MODULE_DESTINATION}\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()

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

# =======================================================================
# Windows
# =======================================================================

# INTERNAL
# Install a binary and its required libraries to a location.
#
# _superbuild_windows_install_binary(
#   LIBDIR <libdir>
#   BINARY <path>
#   TYPE <module|executable>
#   [CLEAN]
#   [DESTINATION <destination>]
#   [LOCATION <location>]
#   [INCLUDE_REGEXES <include-regex>...]
#   [EXCLUDE_REGEXES <exclude-regex>...]
#   [BINARY_LIBDIR <binary_libdirs>...]
#   [SEARCH_DIRECTORIES <search-directory>...])
function (_superbuild_windows_install_binary)
  set(options
    CLEAN)
  set(values
    DESTINATION
    LIBDIR
    LOCATION
    BINARY
    TYPE)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    BINARY_LIBDIR
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_binary "${options}" "${values}" "${multivalues}" ${ARGN})

  if (NOT _install_binary_BINARY)
    message(FATAL_ERROR "Cannot install a binary without a path.")
  endif ()

  if (NOT IS_ABSOLUTE "${_install_binary_BINARY}")
    message(FATAL_ERROR "Cannot install a binary without an absolute path (${_install_binary_BINARY}).")
  endif ()

  if (NOT _install_binary_DESTINATION)
    set(_install_binary_DESTINATION
      "\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}")
  endif ()

  if (NOT _install_binary_LIBDIR)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing where to put dependent libraries.")
  endif ()

  if (NOT _install_binary_TYPE)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing its type.")
  endif ()

  if (_install_binary_TYPE STREQUAL "module" AND NOT _install_binary_LOCATION)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} as a module without knowing where to place it.")
  endif ()

  if (NOT _install_binary_BINARY_LIBDIR)
    list(APPEND _install_binary_BINARY_LIBDIR "bin")
  endif()

  set(fixup_bundle_arguments)
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --destination ${_install_binary_DESTINATION}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --type ${_install_binary_TYPE}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --libdir ${_install_binary_LIBDIR}")

  get_property(superbuild_has_cleaned GLOBAL PROPERTY
    superbuild_has_cleaned)
  if (_install_binary_CLEAN OR NOT superbuild_has_cleaned)
    set_property(GLOBAL PROPERTY
      superbuild_has_cleaned TRUE)
    if (superbuild_is_install_target)
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --new")
    else ()
      set(fixup_bundle_arguments
        "${fixup_bundle_arguments} --clean --new")
    endif ()
  endif ()

  if (_install_binary_LOCATION)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --location \"${_install_binary_LOCATION}\"")
  endif ()

  foreach (include_regex IN LISTS _install_binary_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_binary_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach(binary_libdir IN LISTS _install_binary_BINARY_LIBDIR)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --binary-libdir \"${binary_libdir}\"")
  endforeach()

  foreach (search_directory IN LISTS _install_binary_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${superbuild_python_executable}\"
              \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.windows.py\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/install.manifest\"
              \"${_install_binary_BINARY}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (_superbuild_windows_install_executable path libdir)
  _superbuild_windows_install_binary(
    BINARY      "${path}"
    LIBDIR      "${libdir}"
    TYPE        executable
    ${ARGN})
endfunction ()

function (_superbuild_windows_install_module path subdir libdir)
  _superbuild_windows_install_binary(
    BINARY      "${path}"
    LOCATION    "${subdir}"
    LIBDIR      "${libdir}"
    TYPE        module
    ${ARGN})
endfunction ()

# Install a program from the installation tree to the package.
#
# Usage:
#
#   superbuild_windows_install_program(<path> <libdir>
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [SEARCH_DIRECTORIES <search-directory>...])
#
# Installs a program ``<name>`` into ``bin/`` and its dependent libraies into
# ``<libdir>``.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``SEARCH_DIRECTORIES`` is a list of directories
# to search for dependent libraries.
function (superbuild_windows_install_program name libdir)
  _superbuild_windows_install_executable("${superbuild_install_location}/bin/${name}.exe" "${libdir}" ${ARGN})
endfunction ()

# Install a plugin to the package.
#
# Usage:
#
#   superbuild_windows_install_plugin(<filename> <libdir> <search-paths>
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [SEARCH_DIRECTORIES <search-directory>...])
#
# Install a plugin from ``<filename>`` to the package. The file is searched for
# in ``<search-paths>`` under the superbuild's install tree. Required libraries
# are installed to ``<libdir>``.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``SEARCH_DIRECTORIES`` is a list of directories
# to search for dependent libraries.
function (superbuild_windows_install_plugin name libdir paths)
  if (IS_ABSOLUTE "${name}")
    _superbuild_windows_install_module("${name}" "${paths}" "${libdir}" ${ARGN})
    return ()
  endif ()

  set(found FALSE)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      _superbuild_windows_install_module("${superbuild_install_location}/${path}/${name}" "${path}" "${libdir}" ${ARGN})
      set(found TRUE)
      break ()
    endif ()
  endforeach ()

  if (NOT found)
    string(REPLACE ";" ", " paths_list "${paths}")
    message(FATAL_ERROR "Unable to find the ${name} plugin in ${paths_list}")
  endif ()
endfunction ()

# Install Python modules to the package.
#
# Usage:
#
#   superbuild_windows_install_python(
#     MODULES <module>...
#     MODULE_DIRECTORIES <module-path>...
#     [MODULE_DESTINATION <destination>]
#     [INCLUDE_REGEXES <include-regex>...]
#     [EXCLUDE_REGEXES <exclude-regex>...]
#     [SEARCH_DIRECTORIES <library-path>...])
#
# Installs Python modules or packages named ``<name>`` into the package.
# Libraries are searched for in ``<library-paths>`` and relative paths are
# taken to be relative to the superbuild's install directory. The modules are
# searched for in the ``<module-paths>``. Modules are installed into the proper
# location (``lib/python2.7/site-packages``) within the package, but may be
# placed inside of a different directory by using the ``MODULE_DESTINATION``
# argument.
#
# The ``INCLUDE_REGEXES`` and ``EXCLUDE_REGEXES`` arguments may be used to
# include or exclude found paths from being installed to the package. They are
# Python regular expressions. ``SEARCH_DIRECTORIES`` is a list of directories
# to search for dependent libraries.
function (superbuild_windows_install_python)
  set(values
    MODULE_DESTINATION)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "${options}" "${values}" "${multivalues}" ${ARGN})

  if (NOT _install_python_MODULES)
    message(FATAL_ERROR "No modules specified.")
  endif ()

  if (NOT _install_python_MODULE_DIRECTORIES)
    message(FATAL_ERROR "No modules search paths specified.")
  endif ()

  set(fixup_bundle_arguments)

  if (NOT _install_python_MODULE_DESTINATION)
    set(_install_python_MODULE_DESTINATION "/site-packages")
  endif ()

  foreach (include_regex IN LISTS _install_python_INCLUDE_REGEXES)
    list(APPEND fixup_bundle_arguments
      --include "${include_regex}")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_python_EXCLUDE_REGEXES)
    list(APPEND fixup_bundle_arguments
      --exclude "${exclude_regex}")
  endforeach ()

  foreach (search_directory IN LISTS _install_python_SEARCH_DIRECTORIES)
    list(APPEND fixup_bundle_arguments
      --search "${search_directory}")
  endforeach ()

  install(CODE
    "set(superbuild_python_executable \"${superbuild_python_executable}\")
    include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.windows.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")

    set(fixup_bundle_arguments \"${fixup_bundle_arguments}\")
    set(bundle_destination \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}\")
    set(bundle_manifest \"${CMAKE_BINARY_DIR}/install.manifest\")

    foreach (python_module IN LISTS python_modules)
      superbuild_windows_install_python_module(\"\${CMAKE_INSTALL_PREFIX}\"
        \"\${python_module}\" \"\${module_directories}\" \"bin/Lib${_install_python_MODULE_DESTINATION}\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()
