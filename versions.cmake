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
  URL "http://download.qt-project.org/archive/qt/4.8/4.8.2/qt-everywhere-opensource-src-4.8.2.tar.gz"
  URL_MD5 3c1146ddf56247e16782f96910a8423b)

add_revision(paraview
  GIT_REPOSITORY git://github.com/Kitware/ParaView.git
  GIT_TAG 4386042d5d7ef7b7cac12e96660a7dc5a6c5191a) # lookup_table_cleanup

add_revision(tem
  GIT_REPOSITORY git://kwsource.kitwarein.com/miscellaneousprojectsuda/temtomography.git
  GIT_TAG master)
