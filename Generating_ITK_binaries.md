Making ITK binaries for tomviz superbuild:

***
Windows:
***

First have a build of the superbuild without ITK built.  You need to point ITK at
the correct numpy and fftw headers.

Configure ITK with `-DBUILD_SHARED_LIBS=ON -DITK_LEGACY_SILENT=ON
-DITK_LEGACY_REMOVE=ON -DITK_WRAP_PYTHON=ON -DBUILD_EXAMPLES=OFF
-DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX=temp/install/dir
-DModule_BridgeNumPy=ON
-DNUMPY_INCLUDE_DIR=superbuild/build/dir/install/bin/Lib/site-packages/numpy/core/include
-DITK_USE_FFTWD=ON
-DITK_USE_FFTWF=ON
-DITK_USE_SYSTEM_FFTW=ON
-DFFTWD_LIB=superbuild/build/dir/install/lib/libfftw3.lib
-DFFTWF_LIB=superbuild/build/dir/install/lib/libfftw3f.lib
-DFFTW_INCLUDE_PATH=superbuild/build/dir/install/include
`

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

***
OSX:
***

First have a build of the superbuild without ITK built.  You need to point ITK at
the correct numpy and fftw headers.
Check out ITK release branch or >= 4.9 for compiling for older Mac OS X support.

Configure ITK with
```
-DBUILD_SHARED_LIBS=ON
-DITK_LEGACY_SILENT=ON
-DITK_LEGACY_REMOVE=ON
-DITK_WRAP_PYTHON=ON
-DBUILD_EXAMPLES=OFF
-DBUILD_TESTING=OFF
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX=temp/install/dir
-DCMAKE_OSX_ARCHITECTURES=x86_64
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.8
-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk
-DCMAKE_SKIP_INSTALL_RPATH=OFF
-DCMAKE_SKIP_RPATH=OFF
-DModule_BridgeNumPy=ON
-DNUMPY_INCLUDE_DIR=superbuild/build/dir/install/lib/python2.7/site-packages/numpy/core/include
-DITK_USE_FFTWD=ON
-DITK_USE_FFTWF=ON
-DITK_USE_SYSTEM_FFTW=ON
-DFFTWD_LIB=superbuild/build/dir/install/lib/libfftw3.a
-DFFTWD_THREADS_LIB=superbuild/build/dir/install/lib/libfftw3_threads.a
-DFFTWF_LIB=superbuild/build/dir/install/lib/libfftw3f.a
-DFFTWF_THREADS_LIB=superbuild/build/dir/install/lib/libfftw3f_threads.a
-DFFTW_INCLUDE_PATH=superbuild/build/dir/install/include
```

Build ITK and install it to `temp/install/dir`.

Run the following:
```
cd temp/install/dir
mkdir tmplib
mv lib tmplib/itk
mv tmplib lib
```

This forces the itk installed libraries and such to install into a subfolder of
the lib folder instead of directly into it.  This makes it easier to find what
needs installing in the superbuild bundle creation code.

Then create an archive of the install dir.  Either use zip or:
```
tar czf my-tar-file.tar.gz install-of-itk
```

For Linux, use these instructions but leave out the CMAKE_OSX variables and the RPATH variables
