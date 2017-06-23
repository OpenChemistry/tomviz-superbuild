# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

add_revision(zlib
  URL "http://www.paraview.org/files/dependencies/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)

add_revision(png
  URL "http://paraview.org/files/dependencies/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9)

add_revision(freetype
  URL "http://paraview.org/files/dependencies/freetype-2.4.8.tar.gz"
  URL_MD5 "5d82aaa9a4abc0ebbd592783208d9c76")

add_revision(fontconfig
  URL "http://paraview.org/files/dependencies/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e)

add_revision(libxml2
  URL "http://paraview.org/files/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

if (WIN32)
  if (64bit_build)
    add_revision(ffmpeg
      URL "http://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win64.tar.bz2"
      URL_MD5 887217ae04ee9004e2ec121442553259)
  else ()
    add_revision(ffmpeg
      URL "http://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win32.tar.bz2"
      URL_MD5 b8b3068699e272789ca02df5c132c05c)
  endif ()
else ()
  add_revision(ffmpeg
    URL "http://paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
    URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)
endif ()

if (WIN32)
  add_revision(python
    URL "http://www.tomviz.org/files/python3.6.0.tar.gz"
    URL_MD5 "08c5a23fe5dd095d2aa363816ba25935")
else()
  add_revision(python
    URL "https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tgz"
    URL_MD5 "")
endif()

foreach (fftw3kind float double long quad)
  add_revision(fftw3${fftw3kind}
    URL "http://www.paraview.org/files/dependencies/fftw-3.3.4.tar.gz"
    URL_MD5 2edab8c06b24feeb3b82bbb3ebf3e7b3)
endforeach ()

if (WIN32)
  add_revision(pyfftw
    URL "http://www.tomviz.org/files/pyfftw-0.10.4-win64.zip"
    URL_MD5 "c9c60d3f28df1c9d545152734350f9ba")
else()
  add_revision(pyfftw
    URL "http://www.paraview.org/files/dependencies/pyFFTW-0.9.2.tar.gz"
    URL_MD5 34fcbc68afb8ebe5f040a02a8d20d565)
endif()

add_revision(qt
  URL "http://download.qt.io/official_releases/qt/5.6/5.6.0/single/qt-everywhere-opensource-src-5.6.0.tar.gz"
  URL_MD5 7a2a867bc12384f4161809136d49d4be)

# Default to build from a known ParaView revision
option(USE_PARAVIEW_MASTER "Use ParaView master instead of known ref" OFF)
if(USE_PARAVIEW_MASTER)
  set(_paraview_revision "master")
else()
  # Test the revision with OpenGL2 rendering before updating, update often!
  set(_paraview_revision "95fe92d907a8702b1669b68d5aecf777ae72bcda")
endif()
add_revision(paraview
  GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
  GIT_TAG "${_paraview_revision}")

option(tomviz_FROM_GIT "If enabled then the repository is fetched from git" ON)
cmake_dependent_option(tomviz_FROM_SOURCE_DIR OFF
  "Enable to use existing tomviz source."
  "NOT tomviz_FROM_GIT" OFF)

if (tomviz_FROM_GIT)
  # Download tomviz from GIT
  add_customizable_revision(tomviz
    GIT_REPOSITORY https://github.com/openchemistry/tomviz.git
    GIT_TAG "master")
else()
  if (tomviz_FROM_SOURCE_DIR)
    add_customizable_revision(tomviz
      SOURCE_DIR "TomvizSource")
  else()
    message(FATAL_ERROR "No stable source tarball URL")
  endif()
endif()

add_revision(lapack
  URL "http://paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

if (WIN32)
  add_revision(numpy
    URL "http://www.tomviz.org/files/numpy-1.12.1rc1-py3.6-intel-win64.zip"
    URL_MD5 "a892b14ada262e98a347161618ed74a0")
  add_revision(scipy
    URL "http://www.tomviz.org/files/scipy-0.19.0rc2-py3.6-intel-win64.zip"
    URL_MD5 "ea16b40390b91d2581ea569f3f0246c4")
  add_revision(intelredist
    URL "http://paraview.org/files/dependencies/intel-psxe2015-64-bit-redist.zip"
      URL_MD5 1920a6c593c454ce0f4258aabf5aefe5)
else()
  add_revision(numpy
    URL "http://paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
    URL_MD5 1974dbb4bfa1509e492791a8cd225774)

  add_revision(scipy
    URL "http://www.paraview.org/files/dependencies/scipy-0.15.1.tar.gz"
    URL_MD5 be56cd8e60591d6332aac792a5880110)
endif()

if (WIN32)
  set(_itk_sha512 "f53724a3f7eb8758aded361257ec7d581e4efa0e45ee138e4b6a307b4fc2a980100fdc12c82f9ee14ed539459f2f5078a696292e1dba352edbc595b5ac4d85c3")
  add_revision(itk
    URL "http://www.tomviz.org/files/itk-4.12.0-windows-64bit.zip"
    URL_HASH SHA512=${_itk_sha512})
  add_revision(fftw
    URL "http://www.tomviz.org/files/fftw-3.3.4-windows-64bit.zip"
    URL_MD5 "90ca2a2cd26c62bc85b11ec7f165e716")
elseif(APPLE)
  set(_itk_sha512 "e08c6626c778a6cc99c05253be41cefb04acf6bcf0f89c46cea9937966ef32d1cf2e69787cab57ac2463a1f375d9ab068d51de829f180652816796ba468127fc")
  add_revision(itk
    URL "http://www.tomviz.org/files/itk-v4.12.0-osx-64bit.tar.gz"
    URL_HASH SHA512=${_itk_sha512})
elseif(UNIX)
  set(_itk_sha512 "0686689189b1d855ecbdbc67fab54250267a9d4cc9d57902df87f1ca3f259c0884c17511e95f64715a512b235e84d6deac4db83e2073bbfb79f6f437ba2b7432")
  add_revision(itk
    URL "http://www.tomviz.org/files/itk-v4.12.0-linux-64bit.tar.gz"
    URL_HASH SHA512=${_itk_sha512})
endif()

set(tbb_ver "2017_20160916oss")
if (WIN32)
  set(tbb_file "tbb${tbb_ver}_win_1.zip")
  set(tbb_md5 "d23a6de9b467a89b345de142c36b8abc")
elseif (APPLE)
  set(tbb_file "tbb${tbb_ver}_osx.tgz")
  set(tbb_md5 "e96382f8dbf10e4edbdf1b64605ae891")
else ()
  set(tbb_file "tbb${tbb_ver}_lin.tgz")
  set(tbb_md5 "e668583115832dac196846c8d0fe30ec")
endif ()

add_revision(tbb
  URL "http://www.tomviz.org/files/${tbb_file}"
  URL_MD5 "${tbb_md5}")

