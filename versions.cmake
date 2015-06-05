# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

add_revision(zlib
  URL "http://www.paraview.org/files/dependencies/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)

if (WIN32)
  if (64bit_build)
    add_revision(ffmpeg
      URL "http://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win64.tar.bz2"
      URL_MD5 887217ae04ee9004e2ec121442553259)
  else ()
    add_revision(ffmpeg
      URL "http://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win32.tar.bz2"
      URL_MD5 b8b3068699e272789ca02df5c132c05c)
  endif ()
else ()
  add_revision(ffmpeg
    URL "http://paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
    URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)
endif ()

if (WIN32)
  if (64bit_build)
    add_revision(python
      URL "http://www.paraview.org/files/dependencies/python+deps.tar.bz2"
      URL_MD5 "4318b8f771eda5606d9ce7f0be9f82e1")
  else ()
    add_revision(python
      URL "http://www.paraview.org/files/dependencies/python+deps-x32.tar.bz2"
      URL_MD5 "6ba441784a672e08379d23ddd61146f0")
  endif ()
else()
  add_revision(python
    URL "http://paraview.org/files/v3.98/dependencies/Python-2.7.2.tgz"
    URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7")
endif()

add_revision(numpy
  URL "http://paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
  URL_MD5 1974dbb4bfa1509e492791a8cd225774)

foreach (fftw3kind float double long quad)
  add_revision(fftw3${fftw3kind}
    URL "http://www.fftw.org/fftw-3.3.4.tar.gz"
    URL_MD5 2edab8c06b24feeb3b82bbb3ebf3e7b3)
endforeach ()

add_revision(pyfftw
  URL "https://pypi.python.org/packages/source/p/pyFFTW/pyFFTW-0.9.2.tar.gz"
  URL_MD5 34fcbc68afb8ebe5f040a02a8d20d565)

add_revision(qt
  URL "http://download.qt-project.org/archive/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
  URL_MD5 2edbe4d6c2eff33ef91732602f3518eb)

# Default to build from a known ParaView revision
option(USE_PARAVIEW_MASTER "Use ParaView master instead of known ref" OFF)
if(USE_PARAVIEW_MASTER)
  set(_paraview_revision "master")
else()
  # Test the revision with OpenGL2 rendering before updating, update often!
  set(_paraview_revision "28dfcd039338a2d369672cae51a9ecfc6fbd8ff3")
endif()
add_revision(paraview
  GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
  GIT_TAG "${_paraview_revision}")

option(tomviz_FROM_GIT "If enabled then the repository is fetched from git" ON)
cmake_dependent_option(tomviz_FROM_SOURCE_DIR OFF
  "Enable to use existing TomViz source."
  "NOT tomviz_FROM_GIT" OFF)

if (tomviz_FROM_GIT)
  # Download TomViz from GIT
  add_customizable_revision(tomviz
    GIT_REPOSITORY https://github.com/OpenChemistry/tomviz.git
    GIT_TAG "master")
else()
  if (tomviz_FROM_SOURCE_DIR)
    add_customizable_revision(tomviz
      SOURCE_DIR "TomVizSource")
  else()
    message(FATAL_ERROR "No stable source tarball URL")
  endif()
endif()

add_revision(lapack
  URL "http://paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

add_revision(scipy
    URL "http://softlayer-dal.dl.sourceforge.net/project/scipy/scipy/0.15.1/scipy-0.15.1.tar.gz"
    URL_MD5 be56cd8e60591d6332aac792a5880110)
