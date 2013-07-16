PROJECT(pvr.vdr.vnsi)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

include(AddonVersion.cmake)
addon_version(pvr.vdr.vnsi VDR)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

ENABLE_LANGUAGE(CXX)

OPTION(PACKAGE_ZIP "Package Zip file?" OFF)

ADD_DEFINITIONS(-DUSE_DEMUX)

IF(WIN32)
  SET(BINDING_FILE ${XBMC_BINDINGS}.zip)
  message (STATUS "downloading XBMC bindings: " ${BINDING_FILE})
  file(DOWNLOAD http://mirrors.xbmc.org/build-deps/win32/${BINDING_FILE} ${CMAKE_BINARY_DIR}/downloads/${BINDING_FILE} STATUS STATUSLIST SHOW_PROGRESS)
  LIST(GET STATUSLIST 0 VALUE)
  IF(${VALUE} STRGREATER "0")
    LIST(GET STATUSLIST 1 VALUE)
    message (STATUS "failed to download XBMC bindings: " ${VALUE})
  ENDIF(${VALUE} STRGREATER "0")
  execute_process(
   COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_BINARY_DIR}/downloads/${BINDING_FILE}
  )
  FIND_PATH(XBMC_INCLUDE_DIR xbmc/xbmc_pvr_dll.h ${CMAKE_BINARY_DIR}/include)
  INCLUDE_DIRECTORIES(${XBMC_INCLUDE_DIR})
  ADD_DEFINITIONS(-DTARGET_WINDOWS)
ELSE(WIN32)
  FIND_PATH(XBMC_INCLUDE_DIR xbmc/xbmc_pvr_dll.h)
  FIND_PACKAGE(xbmcplatform REQUIRED)
  FIND_PACKAGE(OpenGLES)
  IF(OPENGLES_FOUND)
    SET(SOURCES src/EGLHelpers/VisGUIShader.cpp
                src/EGLHelpers/VisMatrixGLES.cpp
                src/EGLHelpers/VisShader.cpp)
    ADD_DEFINITIONS(-DHAVE_GLES2)
    INCLUDE_DIRECTORIES(${OPENGLES_INCLUDE_DIR}
                        ${XBMC_INCLUDE_DIR})
    SET(OPENGL_LIBRARIES ${OPENGLES_LIBRARIES})
  ELSE(OPENGLES_FOUND)
    FIND_PACKAGE(OpenGL REQUIRED)
    INCLUDE_DIRECTORIES(${OpenGL_INCLUDE_DIR}
                        ${XBMC_INCLUDE_DIR})
  ENDIF(OPENGLES_FOUND)
ENDIF(WIN32)

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

ADD_LIBRARY(pvr.vdr.vnsi ${SOURCES})
IF(NOT WIN32)
  TARGET_LINK_LIBRARIES(pvr.vdr.vnsi ${xbmcplatform_LIBRARIES}
                                     ${OPENGL_LIBRARIES})
  set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s")
  set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "-s")
ENDIF(NOT WIN32)
SET_TARGET_PROPERTIES(pvr.vdr.vnsi PROPERTIES VERSION ${VDR_VERSION}
                                              SOVERSION 13.0
                                              PREFIX "")

IF(PACKAGE_ZIP)
  # Pack files together to create an archive
  INSTALL(DIRECTORY ${PROJECT_NAME} DESTINATION ./)
  IF(WIN32)
    INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/pvr.vdr.vnsi.dll DESTINATION pvr.vdr.vnsi)
  ELSE(WIN32)
    INSTALL(TARGETS pvr.vdr.vnsi DESTINATION pvr.vdr.vnsi)
  ENDIF(WIN32)
  SET(CPACK_GENERATOR "ZIP")
  SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)
  SET(CPACK_PACKAGE_FILE_NAME ${CMAKE_PROJECT_NAME}-${VDR_VERSION})
  INCLUDE(CPack)
ELSE(PACKAGE_ZIP)
  INSTALL(TARGETS pvr.vdr.vnsi DESTINATION lib/xbmc/addons/pvr.vdr.vnsi)
  INSTALL(DIRECTORY pvr.vdr.vnsi DESTINATION share/xbmc/addons)
ENDIF(PACKAGE_ZIP)
