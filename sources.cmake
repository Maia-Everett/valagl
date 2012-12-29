set(VALAGL_CORE_CLASSES
	CoreError
	GLProgram
	Util
)

foreach(CLASS ${VALAGL_CORE_CLASSES})
	set(APP_SOURCES ${APP_SOURCES} "ValaGL.Core/${CLASS}.vala")
endforeach()

set(VALAGL_CLASSES
	AppError
	App
	Canvas
)

foreach(CLASS ${VALAGL_CLASSES})
	set(APP_SOURCES ${APP_SOURCES} "ValaGL/${CLASS}.vala")
endforeach()
