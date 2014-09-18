message("-- Checking for libgee-0.8...")
pkg_check_modules(GEE gee-0.8)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ExtraDeps DEFAULT_MSG GEE_INCLUDE_DIRS)

if(EXTRADEPS_FOUND)
    set(EXTRA_DEP_INCLUDES ${EXTRA_DEP_INCLUDES} ${GEE_INCLUDE_DIRS})
    set(EXTRA_DEP_CFLAGS ${EXTRA_DEP_CFLAGS} ${GEE_CFLAGS_OTHER})
    set(EXTRA_DEP_LIBS ${EXTRA_DEP_LIBS} ${GEE_LDFLAGS})
endif()
