if (64bit_build)
  set(tbb_archdir intel64)
else ()
  set(tbb_archdir ia32)
endif ()

set(tbb_libdir lib/${tbb_archdir}/gcc4.7)
set(tbb_libsuffix "${CMAKE_SHARED_LIBRARY_SUFFIX}*")
include(tbb.common)
