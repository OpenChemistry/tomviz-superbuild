# Remove packaged version
file(REMOVE_RECURSE "${install_dir}/bin/Lib/site-packages/numpy")

file(GLOB files "numpy/*")
file(INSTALL ${files}
     DESTINATION "${install_dir}/bin/Lib/site-packages/numpy")

