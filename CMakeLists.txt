project(valagl C)
cmake_minimum_required(VERSION 3.10)

# Change version number on release
set(PROJECT_VERSION "0.1.0")
set(COMMON_DATA_DIR ${CMAKE_INSTALL_PREFIX}/share)
set(PROJECT_DATA_DIR ${CMAKE_INSTALL_PREFIX}/share/${CMAKE_PROJECT_NAME})

list(APPEND CMAKE_MODULE_PATH
	${CMAKE_SOURCE_DIR}
	${CMAKE_SOURCE_DIR}/cmake
)

option(BUILD_VALADOC "Build API documentation if Valadoc is available" ON)

set(VALA_REQUIRED_VERSION 0.48)
set(GLIB_REQUIRED_VERSION 2.30.0)
set(GTK_REQUIRED_VERSION 3.0.0)

# Use GLVND, the modern OpenGL ABI
set(OpenGL_GL_PREFERENCE GLVND)

find_package(PkgConfig REQUIRED)
find_package(Vala REQUIRED)
find_package(GLib REQUIRED)
find_package(SDL REQUIRED)
find_package(GLEW REQUIRED)
find_package(OpenGL REQUIRED)

set(HAVE_VALADOC OFF)

if(BUILD_VALADOC)
	find_package(Valadoc)
	
	if(VALADOC_FOUND)
		set(HAVE_VALADOC ON)
		include(Valadoc)
	else()
		message("Valadoc not found, will not build documentation")
	endif()
endif()

include(ValaVersion)
include(ValaPrecompile)
include(sources)

ensure_vala_version(${VALA_REQUIRED_VERSION} MINIMUM)

file (READ ${CMAKE_SOURCE_DIR}/AUTHORS PROJECT_AUTHORS)
string (REPLACE "\n" "\\n\\\n" PROJECT_AUTHORS ${PROJECT_AUTHORS})
configure_file(${CMAKE_SOURCE_DIR}/cmake/config.h.in ${CMAKE_BINARY_DIR}/config.h @ONLY)

set(CUSTOM_VAPIS
	# VAPI containing install definitions, mapping from cmake generated config.h
	${CMAKE_SOURCE_DIR}/vapi/AppConfig.vapi
	# Order is important! GLEW must come before GL and GLU.
	${CMAKE_SOURCE_DIR}/vapi/glew-minimal.vapi
	${CMAKE_SOURCE_DIR}/vapi/gl.vapi
	${CMAKE_SOURCE_DIR}/vapi/glu.vapi
)

set(VALA_PACKAGES
	gio-2.0
	glib-2.0
	sdl
)

vala_precompile(VALA_C
	${APP_SOURCES}
CUSTOM_VAPIS
	${CUSTOM_VAPIS}
PACKAGES
	${VALA_PACKAGES}
OPTIONS
	-g
)

include_directories(
	${GLIB_ALL_INCLUDES}
	${SDL_INCLUDE_DIR}
	${GLEW_INCLUDE_PATH}
	${OPENGL_INCLUDE_DIR}
	${CMAKE_BINARY_DIR}
)

add_definitions(
	${GLIB_ALL_CFLAGS}
)

add_executable(${CMAKE_PROJECT_NAME} ${VALA_C})

target_link_libraries(${CMAKE_PROJECT_NAME}
	${GLIB_ALL_LIBS}
	${SDL_LIBRARY}
	${GLEW_LIBRARY}
	${OPENGL_LIBRARIES}
	-lm
)

if(HAVE_VALADOC)
	valadoc(${CMAKE_PROJECT_NAME}
		${CMAKE_BINARY_DIR}/valadoc
		${APP_SOURCES}
	CUSTOM_VAPIS
		${CUSTOM_VAPIS}
	PACKAGES
		${VALA_PACKAGES}
	)
endif()

include(install)
