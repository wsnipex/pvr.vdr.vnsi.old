PROJECT(pvr.vdr.vnsi)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

ENABLE_LANGUAGE(CXX)

FIND_PACKAGE(xbmc REQUIRED)
FIND_PACKAGE(xbmcplatform REQUIRED)
addon_version(pvr.vdr.vnsi VDR)

ADD_DEFINITIONS(-DUSE_DEMUX)

IF(NOT WIN32)
  FIND_PACKAGE(OpenGLES)
  IF(OPENGLES_FOUND)
    SET(SOURCES src/EGLHelpers/VisGUIShader.cpp
                src/EGLHelpers/VisMatrixGLES.cpp
                src/EGLHelpers/VisShader.cpp)
    ADD_DEFINITIONS(-DHAVE_GLES2)
    SET(INCLUDES ${OPENGLES_INCLUDE_DIR})
    SET(DEPLIBS ${OPENGLES_LIBRARIES})
  ELSE(OPENGLES_FOUND)
    FIND_PACKAGE(OpenGL REQUIRED)
    SET(INCLUDES ${OpenGL_INCLUDE_DIR})
    SET(DEPLIBS ${OPENGL_LIBRARIES})
  ENDIF(OPENGLES_FOUND)
ENDIF(NOT WIN32)

SET(SOURCES ${SOURCES}
            src/client.cpp
            src/requestpacket.cpp
            src/responsepacket.cpp
            src/tools.cpp
            src/VNSIAdmin.cpp
            src/VNSIChannelScan.cpp
            src/VNSIData.cpp
            src/VNSIDemux.cpp
            src/VNSIRecording.cpp
            src/VNSISession.cpp)

SET(DEPLIBS ${DEPLIBS}
            ${xbmcplatform_LIBRARIES})

INCLUDE_DIRECTORIES(${INCLUDES}
                    ${xbmcplatform_INCLUDE_DIRECTORIES}
                    ${XBMC_INCLUDE_DIR})

build_addon(pvr.vdr.vnsi SOURCES DEPLIBS VDR_VERSION)
install_addon(pvr.vdr.vnsi ${VDR_VERSION})
