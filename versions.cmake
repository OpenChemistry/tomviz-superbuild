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

add_revision(cython
  URL "https://www.tomviz.org/files/Cython-0.29.7.tar.gz"
  URL_MD5 24f6a7e0e6691fbecf5880f38cdf880e)

add_revision(pygments
  URL "https://www.tomviz.org/files/Pygments-2.4.2.tar.gz"
  URL_MD5 5ecc3fbb2a783e917b369271fc0e6cd1)

if (WIN32)
  if (64bit_build)
    add_revision(ffmpeg
      URL "https://openchemistry.org/files/tpl/ffmpeg-2.8.15-vs2015-x64.tar.gz"
      URL_MD5 08da7cb4828c53d8c6985ee378bb7ed9)
  else ()
    # The one below probably won't work... may need to build another
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
    URL "https://www.tomviz.org/files/python-3.7.3-win64.tar.gz"
    URL_MD5 "0b0372c946b690c94afc429f1fd21710")
else()
  add_revision(python
    URL "https://www.tomviz.org/files/Python-3.7.3.tgz"
    URL_MD5 "2ee10f25e3d1b14215d56c3882486fcf")
endif()

foreach (fftw3kind float double long quad)
  add_revision(fftw3${fftw3kind}
    URL "https://www.paraview.org/files/dependencies/fftw-3.3.4.tar.gz"
    URL_MD5 2edab8c06b24feeb3b82bbb3ebf3e7b3)
endforeach ()

if (WIN32)
  add_revision(pyfftw
    URL "https://www.tomviz.org/files/pyfftw-0.10.4-win64.zip"
    URL_MD5 "1104e1f912df7d9e390dfec10d89afa3")
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
  set(_paraview_revision "74338e7d6058d0d1cf89405b3c8e932f9d4ea921")
endif()
# Locally patched ParaView repo, or main repo
#set(_paraview_repo "https://gitlab.kitware.com/paraview/paraview.git")
set(_paraview_repo "https://github.com/openchemistry/paraview.git")
add_revision(paraview
  GIT_REPOSITORY "${_paraview_repo}"
  GIT_TAG "${_paraview_revision}")

if (tomviz_FROM_GIT)
  # Download tomviz from GIT
  add_customizable_revision(tomviz
    GIT_REPOSITORY https://github.com/openchemistry/tomviz.git
    GIT_TAG "1.10.0")
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
    URL "https://www.tomviz.org/files/numpy-1.16.3-python3.7.tar.gz"
    URL_HASH "SHA512=786b369073839b2de4e4588c1c87c98004b95feb75807f73bed92cab73dba473dcdf3c96ed899985f46735ba363131ac1eaf9b4b867a568b159aca28f084c6d9")

  add_revision(scipy
    URL "https://www.tomviz.org/files/scipy-1.2.1-python3.7.tar.gz"
    URL_HASH "SHA512=dba897c118d3fc7bb70c9168daf6070a05c6447f12f34dffd3240e2fa22648d120348284e407552032a008e86c6d28e7d990fd007587dc317e5d77dfcaeaba5c")

if (WIN32)
  set(_itk_sha512 "5a7c6b5d7df57f244c0c5dda56debbab025ed503baf9201505d1c437fba0cc89145a475225db0eb5dc9e7bdb116f77bf7caff3d948fa9fab1b51753135d7be0b")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-5.0.0-windows-64bit.zip"
    URL_HASH SHA512=${_itk_sha512})
  add_revision(fftw
    URL "https://www.tomviz.org/files/fftw-3.3.4-windows-64bit.zip"
    URL_MD5 "90ca2a2cd26c62bc85b11ec7f165e716")
elseif(APPLE)
  set(_itk_sha512 "a9f74eb539f23fe8ec00af9ba7aea5ddd2f9d93268d791071af1e1f43603dea2202ca9b4f38fd069622d7ada92cbc4b83f53da2dd21901a05d762ce8524559dd")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-v5.0.0-osx-64bit.tar.gz"
    URL_HASH SHA512=${_itk_sha512})
elseif(UNIX)
  set(_itk_sha512 "b2208467439e02f85b34bcd26822a562d7bf4f7cafaeebfed22b33e533fb4a0c713cfbdd8916a7821c0bdf2fbe8376123e43faa409ad4eeb156e555c7b749569")
  add_revision(itk
    URL "https://www.tomviz.org/files/itk-v5.0.0-linux-64bit.tar.gz"
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


add_revision(marshmallow
  URL "https://github.com/marshmallow-code/marshmallow/archive/3.3.0.tar.gz"
  URL_MD5 fd7fdb99469207bae96a5d5cc2fa1a5b)

add_revision(jsonpointer
  URL "https://github.com/stefankoegl/python-json-pointer/archive/v2.0.tar.gz"
  URL_MD5 95f8263020e8262adf5c627a29561466)

add_revision(jsonpatch
  URL "https://github.com/stefankoegl/python-json-patch/archive/v1.21.zip"
  URL_MD5 a5aac0214434c0db6be86ea77ad8da3f)

set(_holoplay_sha256 "8626082ddc89dbbd018e6113e069eb64c9f8e540db06c4c7e85162dc38b5ddad")
add_revision(holoplay
  URL "https://www.paraview.org/files/dependencies/HoloPlayCore-0.1.1-Open-20200923.tar.gz"
  URL_HASH SHA256=${_holoplay_sha256})
