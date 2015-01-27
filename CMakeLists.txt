project(pvr.vdr.vnsi)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

enable_language(CXX)

find_package(kodi REQUIRED)
find_package(kodiplatform REQUIRED)

add_definitions(-DUSE_DEMUX)

if(NOT WIN32)
  find_package(OpenGLES)
  if(OPENGLES_FOUND)
    find_package(OpenGLES2 REQUIRED)
    set(VDR_SOURCES src/EGLHelpers/VisGUIShader.cpp
                    src/EGLHelpers/VisMatrixGLES.cpp
                    src/EGLHelpers/VisShader.cpp)
    add_definitions(-DHAVE_GLES2)
    set(INCLUDES ${OPENGLES2_INCLUDE_DIRS})
    set(DEPLIBS ${OPENGLES2_LIBRARIES})
  else()
    find_package(OpenGL REQUIRED)
    set(INCLUDES ${OPENGL_INCLUDE_DIR})
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

list(APPEND DEPLIBS ${kodiplatform_LIBRARIES})
if(WIN32)
  list(APPEND DEPLIBS ws2_32)
endif()

include_directories(${INCLUDES}
                    ${kodiplatform_INCLUDE_DIRS}
                    ${KODI_INCLUDE_DIR})

build_addon(pvr.vdr.vnsi VDR DEPLIBS)

include(CPack)
