set (qt_options)
set (patch_command)
if (NOT APPLE AND UNIX)
  list (APPEND qt_options
               -qt-libpng
               -qt-zlib
               -I <INSTALL_DIR>/include/freetype2
               -I <INSTALL_DIR>/include/fontconfig)
  # Fix Qt build failure with GCC 4.1.
 set (patch_command PATCH_COMMAND
                    ${CMAKE_COMMAND} -E copy_if_different
                    ${SuperBuild_PROJECTS_DIR}/patches/qt.src.3rdparty.webkit.Source.WebKit.pri
                    <SOURCE_DIR>/src/3rdparty/webkit/Source/WebKit.pri)
elseif (APPLE)
  list (APPEND qt_options
              -sdk ${CMAKE_OSX_SYSROOT}
              -arch ${CMAKE_OSX_ARCHITECTURES}
              -qt-libpng
              -system-zlib
              )
  # Need to patch Qt code to build with Xcode 4.3 or newer (where SDK
  # location chnages using the following command:
  #find . -name "*.pro" -exec sed -i -e "s:/Developer/SDKs/:.*:g" {} \;
  set (patch_command
       PATCH_COMMAND /usr/bin/find . -name "*.pro" -exec sed -i -e "s:/Developer/SDKs/:.*:g" {} +)
endif()
set(qt_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")

cmake_dependent_option(qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD
  "Work around a build issue in Qt. Use this if you see linker errors with QtHelp and QCLucene." OFF
    "NOT WIN32" OFF)
mark_as_advanced(qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD)

set(qt4_build_commands
  BUILD_COMMAND   make
  INSTALL_COMMAND "make install")
if (qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD)
  # This hack is required because Qt's build gets mucked up when we set
  # LDFLAGS, CXXFLAGS, etc. Installing things makes it work because the files
  # get placed into the install tree which has rpaths so they get found. Since
  # it is such a hack, it is an option which off and hidden by default.
  set(qt4_build_commands
    BUILD_COMMAND   make install
    INSTALL_COMMAND "")
endif ()

add_external_project_or_use_system(
    qt
    DEPENDS zlib
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      -prefix <INSTALL_DIR>
                      -confirm-license
                      -release
                      -no-audio-backend
                      -no-dbus
                      -nomake demos
                      -nomake examples
                      -no-multimedia
                      -no-openssl
                      -no-phonon
                      -no-xinerama
                      -no-scripttools
                      -no-svg
                      -no-declarative
                      -no-declarative-debug
                      -no-xvideo
                      -no-script
                      -no-cups
                      -stl
                      -opensource
                      -qt-libjpeg
                      -qt-libtiff
                      -qt-zlib
                      -no-webkit
                      -xmlpatterns
                      -I <INSTALL_DIR>/include
                      -L <INSTALL_DIR>/lib
                      ${qt_options}
                      ${qt_EXTRA_CONFIGURATION_OPTIONS}
    ${patch_command}
    ${qt4_build_commands}
)

if ((NOT 64bit_build) AND UNIX AND (NOT APPLE))
  # on 32-bit builds, we are incorrectly ending with QT_POINTER_SIZE chosen as
  # 8 (instead of 4) with GCC4.1 toolchain on old debians. This patch overcomes
  # that.
  add_external_project_step(qt-patch-configure
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt.configure
                              <SOURCE_DIR>/configure
    DEPENDEES patch
    DEPENDERS configure)
endif()

if (APPLE)
  # corewlan .pro file needs to be patched to find
  add_external_project_step(qt-patch-corewlan
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt.src.plugins.bearer.corewlan.corewlan.pro
            <SOURCE_DIR>/src/plugins/bearer/corewlan/corewlan.pro
    DEPENDEES configure
    DEPENDERS build)

  # Patch for modal dialog errors on 10.9 and up
  # See https://bugreports.qt-project.org/browse/QTBUG-37699?focusedCommentId=251106#comment-251106
  add_external_project_step(qt-patch-modal-dialogs
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt.src.gui.kernel.qeventdispatcher_mac.mm
                              <SOURCE_DIR>/src/gui/kernel/qeventdispatcher_mac.mm
    DEPENDEES configure
    DEPENDERS build)
endif()
