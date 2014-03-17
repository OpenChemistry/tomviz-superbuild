# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

add_revision(python
  URL "http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz"
  URL_MD5 "2cf641732ac23b18d139be077bd906cd")

add_revision(qt
  URL "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.2.tar.gz"
  URL_MD5 3c1146ddf56247e16782f96910a8423b)

add_revision(pythonqt
  GIT_REPOSITORY git://github.com/commontk/PythonQt.git
  GIT_TAG patched-3)

add_revision(paraview
  GIT_REPOSITORY git://github.com/patmarion/ParaView.git
  GIT_TAG PythonQtPlugin)

add_revision(tem
  GIT_REPOSITORY git://kwsource.kitwarein.com/miscellaneousprojectsuda/temtomography.git
  GIT_TAG master)
