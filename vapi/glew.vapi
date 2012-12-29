[CCode (cprefix = "GLEW", gir_namespace = "GLEW", gir_version = "1.0", lower_case_cprefix = "glew_")]
namespace GLEW {
	[CCode (cheader_filename = "GL/glew.h", cname = "glewInit")]
	public static uint glewInit ();
}
