Making ITK binaries for tomviz superbuild:

Windows:
--------

First have a build of the superbuild without ITK built.  You need to point ITK at
the correct numpy and fftw headers. First, clone ITK and checkout the desired
tag (currently v5.0.1).

Configure ITK like the following (changing any variables that are needed):

```
set tvsb_build_dir=superbuild/build/dir
cmake path/to/source ^
-DCMAKE_BUILD_TYPE=Release ^
-DITK_LEGACY_REMOVE=ON ^
-DITK_LEGACY_SILENT=ON ^
-DModule_ITKBridgeNumPy=ON ^
-DBUILD_TESTING=OFF ^
-DITK_WRAP_unsigned_short=ON ^
-DITK_WRAP_rgb_unsigned_char=OFF ^
-DITK_WRAP_rgba_unsigned_char=OFF ^
-DITK_BUILD_DEFAULT_MODULES=OFF ^
-DITKGroup_Core=ON ^
-DITKGroup_Filtering=ON ^
-DITKGroup_Segmentation=ON ^
-DITKGroup_Nonunit=ON ^
-DCMAKE_INSTALL_PREFIX=temp/install/dir ^
-DNUMPY_INCLUDE_DIR=%tvsb_build_dir%/install/bin/Lib/site-packages/numpy/core/include ^
-DPYTHON_EXECUTABLE=%tvsb_build_dir%/python/src/python/python.exe ^
-DPYTHON_INCLUDE_DIR=%tvsb_build_dir%/python/src/python/include ^
-DPYTHON_LIBRARY=%tvsb_build_dir%/python/src/python/libs/python37.lib ^
-DITK_WRAP_PYTHON=ON ^
-DBUILD_EXAMPLES=OFF ^
-DBUILD_SHARED_LIBS=ON ^
-G "Ninja"
```

You may have to add `-DGIT_EXECUTABLE=/path/to/git.exe` depending on your
install of git.

Build ITK.  Install it to `temp/install/dir`

In a MingGW/GitBash command prompt:
```
cd temp/install/dir
mkdir tmplib
mv lib tmplib/itk
mv tmplib lib
```

This forces the itk installed libraries and such to install into a subfolder of
the lib folder instead of directly into it.  This makes it easier to find what
needs installing in the superbuild bundle creation code.

Then zip up the `temp/install/dir` as the binary ditribution of itk to be used
with tomviz superbuild.

OSX:
----

Run the `make_itk_bundle_osx.sh` script in the `itk-binaries/osx` folder.  It
will generate the ITK tarball for OSX in the current directory assuming that your
XCode has the appropriate SDK (currently 10.9) installed.  If you want to use a
different SDK, you will need to modify the script to point to the SDK
you want to build ITK with.

LINUX:
------

Install Docker.

Go to the itk-binaries/linux folder in this repository and run the following:

```
docker build -t itk-binary-builder .
docker run -t -i --rm itk-binary-builder
```

This will open a shell inside the container.  At this shell run the following:

```
cd ~
./make_itk_bundle.sh
```

This will generate the itk binaries to ~/dev/itk/itk-VERSION-linux-64bit.tar.gz.
You can then use `scp` to put this file where you need the new binary to be.

