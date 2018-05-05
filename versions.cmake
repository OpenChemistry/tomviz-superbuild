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
  URL "https://www.paraview.org/files/dependencies/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)

add_revision(png
  URL "https://paraview.org/files/dependencies/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9)

add_revision(freetype
  URL "https://paraview.org/files/dependencies/freetype-2.4.8.tar.gz"
  URL_MD5 "5d82aaa9a4abc0ebbd592783208d9c76")

add_revision(fontconfig
  URL "https://paraview.org/files/dependencies/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e)

add_revision(libxml2
  URL "https://paraview.org/files/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

if (WIN32)
  if (64bit_build)
    add_revision(ffmpeg
      URL "https://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win64.tar.bz2"
      URL_MD5 887217ae04ee9004e2ec121442553259)
  else ()
    add_revision(ffmpeg
      URL "https://paraview.org/files/dependencies/ffmpeg-kitware-20150514gitbc25918-win32.tar.bz2"
      URL_MD5 b8b3068699e272789ca02df5c132c05c)
  endif ()
else ()
  add_revision(ffmpeg
    URL "https://paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
    URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)
endif ()

if (WIN32)
  add_revision(python
    URL "https://www.tomviz.org/files/python-3.6.4-win64.tar.gz"
    URL_MD5 "2edcf1b7a2df4fe3aa9c9aee6a6a353e")
else()
  add_revision(python
    URL "https://www.tomviz.org/files/Python-3.6.4.tgz"
    URL_MD5 "9de6494314ea199e3633211696735f65")
endif()

foreach (fftw3kind float double long quad)
  add_revision(fftw3${fftw3kind}
    URL "https://www.paraview.org/files/dependencies/fftw-3.3.4.tar.gz"
    URL_MD5 2edab8c06b24feeb3b82bbb3ebf3e7b3)
endforeach ()

if (WIN32)
  add_revision(pyfftw
    URL "https://www.tomviz.org/files/pyfftw-0.10.4-win64.zip"
    URL_MD5 "c9c60d3f28df1c9d545152734350f9ba")
else()
  add_revision(pyfftw
    URL "https://www.tomviz.org/files/pyFFTW-0.10.4.tar.gz"
    URL_HASH "SHA512=6848133e30a02ee51bb86613f53a5fdbf9b5a0fea3cab01b8ca7d365f924a966ac9b94f4ed62979d418f9f847369f8c50568ca855e472035fa37e86e630fb9fd" )
endif()

add_revision(qt
  URL "http://download.qt.io/official_releases/qt/5.6/5.6.0/single/qt-everywhere-opensource-src-5.6.0.tar.gz"
  URL_MD5 7a2a867bc12384f4161809136d49d4be)

# Default to build from a known ParaView revision
option(USE_PARAVIEW_MASTER "Use ParaView master instead of known ref" OFF)
if(USE_PARAVIEW_MASTER)
  set(_paraview_revision "master")
else()
  # Test the revision locally before proposing a move
  set(_paraview_revision "b9a216aa78b1570bbd6e73133730782f4a6efdae")
endif()
# Locally patched ParaView repo, or main repo
#set(_paraview_repo "https://gitlab.kitware.com/paraview/paraview.git")
set(_paraview_repo "https://github.com/openchemistry/paraview.git")
add_revision(paraview
  GIT_REPOSITORY "${_paraview_repo}"
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
  URL "https://paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

  # since the OSX python can't build with SSL unless we add openssl to the superbuild,
  # these are the linux + osx binaries from PYPI downloaded and uploaded to our dependencies site.
  # We can download and install them from there
  add_revision(numpy
    URL "https://www.tomviz.org/files/numpy-1.14.0-python3.6.tar.gz"
    URL_HASH "SHA512=41d8bd3e83072f2040af5d995e3700aaec431f021f56c40a364f3679baa38ca3c6e66dd51749d116461ffc425c8e1f0c5c2050b3f2e1760d60d7c74744e60db2")

  add_revision(scipy
    URL "https://www.tomviz.org/files/scipy-1.0.0-python3.6.tar.gz"
    URL_HASH "SHA512=b76907671015e23f3f2837c165eb055533dd9ea58cf36f82af49607012ddf44ed761fab697d3a86819faac7479a1ea3b55e91066c86974ae55b3679c81cfb870")

if (WIN32)
  set(_itk_sha512 "de4561f2c9865633d17c63e546800504e9d991e2fefe2a23c27bf3b7d9807a118aa02dfe128af72d7bd4c452dce1dac6fdb53e67dea93963774a59b27628173a")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-4.12.0-windows-64bit.zip"
    URL_HASH SHA512=${_itk_sha512})
  add_revision(fftw
    URL "https://www.tomviz.org/files/fftw-3.3.4-windows-64bit.zip"
    URL_MD5 "90ca2a2cd26c62bc85b11ec7f165e716")
elseif(APPLE)
  set(_itk_sha512 "e08c6626c778a6cc99c05253be41cefb04acf6bcf0f89c46cea9937966ef32d1cf2e69787cab57ac2463a1f375d9ab068d51de829f180652816796ba468127fc")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-v4.12.0-osx-64bit.tar.gz"
    URL_HASH SHA512=${_itk_sha512})
elseif(UNIX)
  set(_itk_sha512 "39aa2bd22e1e2461656abd8983df7c4487978a5e47de006e9d8d8f3eb48c2db42fb4952d1230e3064e7241c6dd811d8a206b5e16f99fd6ee4aa861d3bd4bc8e6")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-v4.12.0-linux-64bit.tar.gz"
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
  URL "https://www.tomviz.org/files/${tbb_file}"
  URL_MD5 "${tbb_md5}")

