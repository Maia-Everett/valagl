message("-- Checking for libgee...")
pkg_check_modules(GEE gee-1.0)

if(GEE_FOUND)
    set(EXTRA_DEP_INCLUDES ${EXTRA_DEP_INCLUDES} ${GEE_INCLUDE_DIRS})
    set(EXTRA_DEP_CFLAGS ${EXTRA_DEP_CFLAGS} ${GEE_CFLAGS_OTHER})
    set(EXTRA_DEP_LIBS ${EXTRA_DEP_LIBS} ${GEE_LDFLAGS})
else()
    message(FATAL_ERROR "libgee not found")
endif()

set(EXTRA_DEP_LIBS -lSDL_gfx -lGLEW -lGL -lGLU)
