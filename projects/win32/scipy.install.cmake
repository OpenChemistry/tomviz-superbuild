file(GLOB files "scipy/*")
file(INSTALL ${files}
     DESTINATION "${install_dir}/bin/Lib/site-packages/scipy")
