# Remove packaged version
file(REMOVE_RECURSE "${install_dir}/bin/Lib/site-packages/numpy")
file(REMOVE "${install_dir}/bin/Lib/site-packages/numpy-1.8.1-py2.7.egg-info")

file(GLOB files "numpy/*")
file(INSTALL ${files}
     DESTINATION "${install_dir}/bin/Lib/site-packages/numpy")
file(INSTALL numpy-1.8.1-py2.7.egg-info
     DESTINATION "${install_dir}/bin/Lib/site-packages/")

