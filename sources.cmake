set(VALAGL_CORE_CLASSES
	_namespace
	Camera
	CoreError
	GeometryUtil
	GLProgram
	IBO
	MatrixMath
	Util
	VAO
	VBO
)

foreach(CLASS ${VALAGL_CORE_CLASSES})
	set(APP_SOURCES ${APP_SOURCES} "ValaGL.Core/${CLASS}.vala")
endforeach()

set(VALAGL_CLASSES
	_namespace
	AppError
	App
	Canvas
)

foreach(CLASS ${VALAGL_CLASSES})
	set(APP_SOURCES ${APP_SOURCES} "ValaGL/${CLASS}.vala")
endforeach()
