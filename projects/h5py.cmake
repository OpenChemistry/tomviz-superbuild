superbuild_add_project_python(h5py DEPENDS hdf5 six pkgconfig cython numpy INSTALL_WITH_PIP ON)
enable_project(h5py "")
