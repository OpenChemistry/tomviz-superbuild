add_external_project_or_use_system(fftw3quad
CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-threads
                    --enable-quad-precision
)
