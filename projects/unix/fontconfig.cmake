if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()
add_external_project(
  fontconfig
  DEPENDS freetype libxml2
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-docs
                    --enable-libxml2
                    ${shared_args}
                    --with-freetype-config=<INSTALL_DIR>/bin/freetype-config
  PROCESS_ENVIRONMENT
                    LIBXML2_CFLAGS -I<INSTALL_DIR>/include/libxml2
                    LIBXML2_LIBS -lxml2
)
