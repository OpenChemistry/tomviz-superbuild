if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()

add_external_project(
  ffmpeg
  DEPENDS zlib
  CONFIGURE_COMMAND "<SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-avdevice
                    --disable-bzlib
                    --disable-decoders
                    --disable-doc
                    --disable-ffplay
                    --disable-ffprobe
                    --disable-ffserver
                    --disable-network
                    --disable-yasm
                    ${shared_args}
                    # --cc=${CMAKE_C_COMPILER}
                    \"--extra-cflags=${cppflags}\"
                    \"--extra-ldflags=${ldflags}\"
                    ${extra_commands}"
  BUILD_IN_SOURCE 1
)
