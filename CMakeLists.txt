project(pvr.vdr.vnsi)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

enable_language(CXX)

find_package(xbmc REQUIRED)
find_package(xbmcplatform REQUIRED)

add_definitions(-DUSE_DEMUX)

if(NOT WIN32)
  find_package(OpenGLES)
  if(OPENGLES_FOUND)
    include(FindPkgConfig)
    pkg_check_modules(OpenGLES2 REQUIRED glesv2)
    set(VDR_SOURCES src/EGLHelpers/VisGUIShader.cpp
                    src/EGLHelpers/VisMatrixGLES.cpp
                    src/EGLHelpers/VisShader.cpp)
    add_definitions(-DHAVE_GLES2)
    set(INCLUDES ${OPENGLES_INCLUDE_DIR})
    set(DEPLIBS ${OPENGLES_LIBRARIES})
  else()
    find_package(OpenGL REQUIRED)
    set(INCLUDES ${OpenGL_INCLUDE_DIR})
    set(DEPLIBS ${OPENGL_LIBRARIES})
  endif()
endif()

list(APPEND VDR_SOURCES src/client.cpp
                        src/requestpacket.cpp
                        src/responsepacket.cpp
                        src/tools.cpp
                        src/VNSIAdmin.cpp
                        src/VNSIChannels.cpp
                        src/VNSIChannelScan.cpp
                        src/VNSIData.cpp
                        src/VNSIDemux.cpp
                        src/VNSIRecording.cpp
                        src/VNSISession.cpp)

list(APPEND DEPLIBS ${xbmcplatform_LIBRARIES})

include_directories(${INCLUDES}
                    ${xbmcplatform_INCLUDE_DIRECTORIES}
                    ${XBMC_INCLUDE_DIR})

build_addon(pvr.vdr.vnsi VDR DEPLIBS)

include(CPack)
