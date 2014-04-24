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
  add_revision(python
    URL "http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz"
    URL_MD5 "2cf641732ac23b18d139be077bd906cd")
else()
  add_revision(python
    URL "http://paraview.org/files/v3.98/dependencies/Python-2.7.2.tgz"
    URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7")
endif()

add_revision(qt
  URL "http://download.qt-project.org/archive/qt/4.8/4.8.2/qt-everywhere-opensource-src-4.8.2.tar.gz"
  URL_MD5 3c1146ddf56247e16782f96910a8423b)

add_revision(paraview
  GIT_REPOSITORY git://github.com/Kitware/ParaView.git
  GIT_TAG 4386042d5d7ef7b7cac12e96660a7dc5a6c5191a) # lookup_table_cleanup

add_revision(matviz
  GIT_REPOSITORY https://github.com/cryos/matviz
  GIT_TAG master)
