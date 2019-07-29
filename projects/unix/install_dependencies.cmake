# this file determines binary dependencies for ParaView and install thems.

# dependencies_root == directory where dependecies are installed.
# target_root == root directory where files are to be installed.

include(GetPrerequisites)

get_filename_component(exepath "${executable}" PATH)
get_filename_component(exename "${executable}" NAME)

set(dirs ${dependencies_root}/lib ${dependencies_root}/lib/paraview)
if (qt_root)
  list(APPEND dirs ${qt_root}/lib)
endif()

# This function overrides the type of a file when `get_prerequesites()`
# is called. We will use it so that *libcrypt* will be installed along
# with the other libraries. Otherwise, it would be considered a system
# library, and it would not be installed.
function(gp_resolved_file_type_override filename type)
  if(filename MATCHES "(.*)libcrypt(.*)")
    set(type "other" PARENT_SCOPE)
  endif()
endfunction()

message("Determining dependencies for '${exename}'")
get_prerequisites(
  ${executable}
  prerequisites
  1
  1
  ${exepath}
  "${dirs}"
  )

message("Installing dependencies for '${exename}'")

set(target_file_locations ${target_root} ${target_root}/paraview)

# resolve symlinks.
set (resolved_prerequisites)
foreach(link ${prerequisites})
  if (NOT link MATCHES ".*fontconfig.*")
    set(full_path full_path-NOTFOUND)
    # See if we already installed it
    get_filename_component(libname ${full_path} NAME)
    find_file(full_path
      NAMES "${libname}"
      PATHS ${target_file_locations}
      NO_DEFAULT_PATH)

    if (NOT full_path)
      if (IS_SYMLINK ${link})
        get_filename_component(resolved_link "${link}" REALPATH)
        # now link may not directly point to resolved_link.
        # so we install the resolved link as the link.
        get_filename_component(resolved_name "${link}" NAME)
        file(INSTALL
          DESTINATION "${target_root}"
          TYPE PROGRAM
          RENAME "${resolved_name}"
          FILES "${resolved_link}")
      else ()
        list(APPEND resolved_prerequisites ${link})
      endif()
    endif()
  endif()
endforeach()

file(INSTALL ${resolved_prerequisites}
     DESTINATION ${target_root}
     USE_SOURCE_PERMISSIONS)
#file(INSTALL
#     DESTINATION ${target_root}/../../doc)
#file(DOWNLOAD "http://www.paraview.org/files/v${pv_version}/ParaViewUsersGuide.v${pv_version}.pdf"
#     ${target_root}/../../doc/ParaViewUsersGuide.v3.14.pdf
#     SHOW_PROGRESS)
