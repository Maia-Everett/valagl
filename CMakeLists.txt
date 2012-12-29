project(valagl C)
cmake_minimum_required(VERSION 2.6)

# Change version number on release
set(PROJECT_VERSION "0.1.0")
set(COMMON_DATA_DIR ${CMAKE_INSTALL_PREFIX}/share)
set(PROJECT_DATA_DIR ${CMAKE_INSTALL_PREFIX}/share/${CMAKE_PROJECT_NAME})

list(APPEND CMAKE_MODULE_PATH
	${CMAKE_SOURCE_DIR}
	${CMAKE_SOURCE_DIR}/cmake
)

set(VALA_REQUIRED_VERSION 0.16)
set(GLIB_REQUIRED_VERSION 2.30.0)
set(GTK_REQUIRED_VERSION 3.0.0)

find_package(PkgConfig REQUIRED)
find_package(Vala REQUIRED)
find_package(GLib REQUIRED)
find_package(ExtraDeps REQUIRED)

include(ValaVersion)
include(ValaPrecompile)
include(GSettings)
#include(Po)
include(sources)

ensure_vala_version(${VALA_REQUIRED_VERSION} MINIMUM)

file (READ ${CMAKE_SOURCE_DIR}/AUTHORS PROJECT_AUTHORS)
string (REPLACE "\n" "\\n\\\n" PROJECT_AUTHORS ${PROJECT_AUTHORS})
configure_file(${CMAKE_SOURCE_DIR}/cmake/config.h.in ${CMAKE_BINARY_DIR}/config.h @ONLY)

set(CUSTOM_VAPIS
	# VAPI containing install definitions, mapping from cmake generated config.h
	#${CMAKE_SOURCE_DIR}/vapi/AppConfig.vapi
	${CMAKE_SOURCE_DIR}/vapi/glew.vapi
	${CMAKE_SOURCE_DIR}/vapi/gl.vapi
)

set(VALA_PACKAGES
	gee-1.0
	gio-2.0
	glib-2.0
)

vala_precompile(VALA_C
	${${CMAKE_PROJECT_NAME}_SOURCES}
CUSTOM_VAPIS
	${CUSTOM_VAPIS}
PACKAGES
	${VALA_PACKAGES}
)

# Generate .mo from .po
# compile_po_files(${CMAKE_SOURCE_DIR}/po LOCALE_FILES)

include_directories(${GTK3_ALL_INCLUDES} ${EXTRA_DEP_INCLUDES} ${CMAKE_BINARY_DIR})
add_definitions(${GTK3_ALL_CFLAGS} ${EXTRA_DEP_CFLAGS}
	-DGETTEXT_PACKAGE=\"${CMAKE_PROJECT_NAME}\"
)

add_executable(${CMAKE_PROJECT_NAME} ${VALA_C})
target_link_libraries(${CMAKE_PROJECT_NAME} ${GLIB_ALL_LIBS} ${EXTRA_DEP_LIBS})

include(install)
