file(GLOB files "*")

# Get rid of vcruntime*.dll, or we will install multiple copies of it
# This fix prevents an error with WIX
list(FILTER files EXCLUDE REGEX ".*vcruntime[0-9]+\\.dll")

file(INSTALL ${files}
  DESTINATION "${install_dir}/bin/")
