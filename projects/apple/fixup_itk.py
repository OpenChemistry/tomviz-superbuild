#!/usr/bin/env python

import sys
import commands
import os.path
import re
import shutil

def _getid(lib):
  """Returns the id for the library"""
  val = commands.getoutput("otool -D %s" % lib)
  m = re.match(r"[^:]+:\s*([^\s]+)", val)
  if m:
    return m.group(1)
  else:
    # This happens on the python C++ code bundles
    return None

def _getlibinfo(lib):
  Id = _getid(lib)
  libname = os.path.basename(lib)
  fullpath = os.path.abspath(lib)
  return (Id, libname, fullpath)

if __name__ == "__main__":
  itk_dir = sys.argv[1]

  print "------------------------------------------"
  print "Fixing up ITK libraries"
  print ""

  libraries = commands.getoutput('find %s -type f | xargs file | grep -i "Mach-O.*" | sed "s/:.*//" | sort' % itk_dir)
  libraries = libraries.split()

  print "Found %d libraries" % len(libraries)

  libinfo = [_getlibinfo(lib) for lib in libraries]

  install_name_tool_args = []
  for info in libinfo:
    print 'Changing Id for %s' % info[2]
    if info[0] is not None:
      commands.getoutput('install_name_tool -id %s %s' % (info[2], info[2]))
      install_name_tool_args += ["-change", '"%s"' % info[0], '"%s"' % info[2]]

  print ''
  install_name_tool_args = " ".join(install_name_tool_args)

  for lib in libraries:
    print 'Fixing dependencies for %s' % lib
    commands.getoutput('install_name_tool %s %s' % (install_name_tool_args, lib))
