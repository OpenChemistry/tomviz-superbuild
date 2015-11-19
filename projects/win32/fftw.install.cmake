file(GLOB libraries *.dll)
foreach (dll ${libraries})
  file(INSTALL ${dll}
       DESTINATION ${install_dir}/bin)
endforeach()

file(GLOB libfiles *.lib)
foreach (lib ${libfiles})
  file(INSTALL ${lib}
       DESTINATION ${install_dir}/lib)
endforeach()

file(INSTALL fftw3.h
     DESTINATION ${install_dir}/include)
