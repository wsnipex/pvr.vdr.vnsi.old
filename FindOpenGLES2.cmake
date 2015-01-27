# - Try to find OpenGLES2
# Once done this will define
#
#  OPENGLES2_FOUND        - system has OpenGLES2
#  OPENGLES2_INCLUDE_DIR  - the GLES2 include directory
#  OPENGLES2_LIBRARIES    - Link these to use OpenGLES2

find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(OpenGLES2 glesv2)
endif(PKG_CONFIG_FOUND)

if(NOT OPENGLES2_FOUND)
  if(APPLE)
    # TODO: this might need some attention
    set(OPENGLES2_gl_LIBRARY "-framework OpenGLES")
  else(APPLE)
    find_path(OPENGLES2_INCLUDE_DIRS GLES2/gl2.h)
    find_library(OPENGLES2_gl_LIBRARY NAMES GLESv2)
    find_library(OPENGLES2_egl_LIBRARY NAMES EGL)
  endif(APPLE)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(OpenGLES2 DEFAULT_MSG
    OPENGLES2_INCLUDE_DIRS OPENGLES2_gl_LIBRARY OPENGLES2_egl_LIBRARY)

  set(OPENGLES2_LIBRARIES ${OPENGLES2_gl_LIBRARY} ${OPENGLES2_egl_LIBRARY})
endif(NOT OPENGLES2_FOUND)

mark_as_advanced(
  OPENGLES2_INCLUDE_DIRS
  OPENGLES2_LIBRARIES
  OPENGLES2_gl_LIBRARY
  OPENGLES2_egl_LIBRARY
)
