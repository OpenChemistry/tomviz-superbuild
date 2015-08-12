Making ITK binaries for tomviz superbuild:

***
Windows:
***
Configure ITK with `-DBUILD_SHARED_LIBS=ON -DITK_LEGACY_SILENT=ON
-DITK_LEGACY_REMOVE=ON -DITK_WRAP_PYTHON=ON -DBUILD_EXAMPLES=OFF
-DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX=temp/install/dir`

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

Check out ITK release or >= 4.9 for compiling for older Mac OS X support.

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
-DCMAKE_INSTALL_RPATH=@executable_path/../Libraries:@executable_path/../Libraries/ITK-4.8/Python
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
