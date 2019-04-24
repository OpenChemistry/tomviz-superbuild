Building FFMPEG with Visual Studio
==================================

Building FFMPEG with Visual Studio requires several steps and can be challenging.
Below is a guide that worked for building FFMPEG 2.8.15 with Visual Studio 2015
for tomviz. Many of these steps were taken from the
[official guide](https://www.ffmpeg.org/platform.html#Microsoft-Visual-C_002b_002b-or-Intel-C_002b_002b-Compiler-for-Windows)
and another [helper guide](https://trac.ffmpeg.org/wiki/CompilationGuide/MSVC).

## Install Visual Studio
Ensure that Visual Studio is installed, and that a
[developer command prompt](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs)
can be started. 64-bit Visual Studio 2015 was used for this guide.

## Install MSYS2
The official method for building FFMPEG with Visual Studio requires [MSYS2](https://www.msys2.org/).
Download and install MSYS2, and remember where it was installed.

Next, open up an MSYS2 shell and install some dependencies. This can be done with the following command:
```
pacman -S git make gcc diffutils mingw-w64-x86_64-pkg-config mingw-w64-i686-nasm
```

You may wish to rename the link at `/usr/bin/link.exe` to be `/usr/bin/link.exe.bak` so
that in future steps, `which link.exe` will return the Visual Studio executable rather than
`/usr/bin/link.exe`.

## Clone FFMPEG and Checkout Version
Clone in FFMPEG using the following command:
```
git clone https://github.com/ffmpeg/ffmpeg
```

Next, check out the version you wish to build. For this guide, we used 2.8.15.
```
cd ffmpeg
git checkout n2.8.15
```

## Build FFMPEG
Start by opening up a Visual Studio developer command prompt. This is done so that the
environment variables will be set up before opening up MSYS2.

Next, open an MSYS2 shell with the following command
(Be sure to replace `C:\Tools\...` with the correct path to MSYS2):
```
C:\Tools\msys64\msys2_shell.cmd -mingw32 -use-full-path
```

This should open up an MSYS2 shell that has the Visual Studio environment set up.
Typing `which nmake` should return the nmake executable. Make sure that `which link`
returns the `link` executable in Visual Studio, NOT the one at `/usr/bin/link.exe`
(you may need to move `/usr/bin/link.exe` if `which link` returns the wrong one).

Next, enter the FFMPEG directory and run the following configure command (tested on FFMPEG
2.8.15):
```
./configure --enable-static --disable-shared --enable-runtime-cpudetect --disable-bzlib --disable-zlib --disable-avdevice --disable-decoders --disable-doc --disable-ffplay --disable-ffprobe --disable-ffserver --disable-network --disable-yasm --toolchain=msvc --target-os=win64 --arch=x86_64 --prefix=./install
```

This will take a while, so be patient. If an error occurs during this step, check the log file
in `ffbuild/config.log` for more information.

After configuration completes, build and install the program:
```
make install
```

If it builds successfully, and it installs successfully, then the binaries will be in
`./install`!

## Testing on Tomviz
Re-build tomviz using the new FFMPEG binaries above, then build a package and install the package.

Open up tomviz, and open up a sample data set. Go to `File`->`Export Movie...`, and choose an
`AVI` file. Save it somewhere.

If an error pops up during saving such as `Could not open the avi media file format` from vtkFFMPEGWriter.cxx,
then something is wrong with the binaries.

Otherwise, if you can open up the saved movie file and view the movie, then the binaries worked!
