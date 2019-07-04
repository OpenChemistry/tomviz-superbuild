Building pyFFTW with Visual Studio
==================================

These are instructions used to build pyFFTW 0.10.4 using Visual
Studio 2015. Hopefully, other versions of pyFFTW 0.10.4 and Visual
Studio will be similar. Many of the instructions can be found in the
[pyFFTW README](https://github.com/pyFFTW/pyFFTW/blob/v0.10.4/README.rst).

Essentially, python is required with the following dependencies:
 * Numpy
 * FFTW
 * Cython

Cython is only required for building, not for runtime.

For tomviz, it is convenient to use the buildbot's install directory of
the tomviz-superbuild. However, a copy should probably be made as
Cython will need to be installed.

After making a copy of the tomviz-superbuild install directory,
download Cython and install it using the python in the
tomviz-superbuild install directory like so:
```
python setup.py build
python setup.py install
```

Once it is installed, download the pyFFTW 0.10.4 source code, and
unzip it. Next, copy the fftw3 dll's and libs that tomviz-superbuild
created into the `pyfftw` directory like so:
```
copy path\to\superbuild\install\bin\libfftw3* .\pyFFTW-0.10.4\pyfftw\
copy path\to\superbuild\install\lib\libfftw3* .\pyFFTW-0.10.4\pyfftw\
```

Also copy the header over, like so:
```
copy path\to\superbuild\install\include\fftw3.h .\pyFFTW-0.10.4\pyfftw\
```

Next, you can `cd` into the directory and build pyFFTW like so:
```
path\to\superbuild\install\bin\python.exe setup.py build
```

The binaries will be placed in `.\build\lib.win-amd64-3.7`, where
the `3.7` is the python version.

A Note About pyFFTW 0.11.1
--------------------------

PyFFTW 0.11.1 can be compiled in the same way, but there appear to be
issues with the environment sniffer on Windows. As in, it complains
that it can't find the fftw3 header file or the fftw3 libraries, even
though they are in the correct place. If I comment out those lines,
though ([here](https://github.com/pyFFTW/pyFFTW/blob/09ecbe3f864eb829241eebf990d4332c4164bb1b/setup.py#L217)
and [here](https://github.com/pyFFTW/pyFFTW/blob/09ecbe3f864eb829241eebf990d4332c4164bb1b/setup.py#L323)),
and the files are truly in the right places, it compiles just fine.
