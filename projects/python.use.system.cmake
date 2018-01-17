find_package(PythonLibs 3.6 REQUIRED)
find_package(PythonInterp 3.6 REQUIRED)

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
  -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
  -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
  -DPARAVIEW_PYTHON_VERSION:STRING=3
)

set (pv_python_executable "${PYTHON_EXECUTABLE}" CACHE INTERNAL "" FORCE)

get_filename_component(python_exe_dir "${PYTHON_EXECUTABLE}" DIRECTORY)
find_program(python_pip_executable pip3 HINTS ${python_exe_dir} PATH_SUFFIXES "Scripts")
