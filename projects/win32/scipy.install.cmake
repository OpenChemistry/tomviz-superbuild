file(GLOB files "scipy/*")
file(INSTALL ${files}
     DESTINATION "${install_dir}/bin/Lib/site-packages/scipy")
file(INSTALL scipy-0.15.1-py2.7.egg-info
     DESTINATION "${install_dir}/bin/Lib/site-packages/")