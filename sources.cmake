set(VALAGL_CLASSES
	App
)

foreach(CLASS ${VALAGL_CLASSES})
	set(VALAGL_SOURCES ${VALAGL_SOURCES} "ValaGL/${CLASS}.vala")
endforeach()
