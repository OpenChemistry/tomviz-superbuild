# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

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

add_revision(paraview
  GIT_REPOSITORY https://gitlab.kitware.com/paraview/paraview.git
  GIT_TAG master)

add_revision(tomviz
  GIT_REPOSITORY https://github.com/OpenChemistry/matviz
  GIT_TAG master)
