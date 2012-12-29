/*
    GLProgram.vala
    Copyright (C) 2012 Maia Everett <maia@everett.one>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

using GL;

namespace ValaGL.Core {

public class GLProgram : Object {
	private GLuint vertex_shader = 0;
	private GLuint fragment_shader = 0;
	private GLuint prog_id = 0;
	
	public GLProgram (string vertex_shader_file, string fragment_shader_file) throws CoreError {
		vertex_shader = create_shader_from_file (GL_VERTEX_SHADER, vertex_shader_file);
		fragment_shader = create_shader_from_file (GL_FRAGMENT_SHADER, fragment_shader_file);
		
		prog_id = glCreateProgram ();
		
		if (prog_id == 0) {
			throw new CoreError.SHADER_INIT ("Cannot allocate GL program ID");
		}
		
		glAttachShader (prog_id, vertex_shader);
		glAttachShader (prog_id, fragment_shader);
		glLinkProgram (prog_id);

		GLint link_ok = GL_FALSE;
		glGetProgramiv (prog_id, GL_LINK_STATUS, out link_ok);
		
		if (link_ok != GL_TRUE) {
			throw new CoreError.SHADER_INIT ("Cannot link GL program");
		}
	}
	
	~GLProgram () {
		if (vertex_shader != 0) {
			glDeleteShader (vertex_shader);
		}
		
		if (fragment_shader != 0) {
			glDeleteShader (fragment_shader);
		}
		
		if (prog_id != 0) {
			glDeleteProgram (prog_id);
		}
	}
	
	public GLint get_attrib_location (string name) {
		assert (prog_id != 0);
		return glGetAttribLocation (prog_id, (GLchar[]) name.data);
	}
	
	public void make_current () {
		assert (prog_id != 0);
		glUseProgram (prog_id);
	}
	
	private static GLuint create_shader_from_file (GLuint shader_type, string file_path) throws CoreError {
		try {
			uint8[] file_contents;
			File.new_for_path (file_path).load_contents (null, out file_contents, null);
			return create_shader_from_string (shader_type, (string) file_contents);
		} catch (Error e) {
			throw new CoreError.SHADER_INIT (e.message);
		}
	}
	
	private static GLuint create_shader_from_string (GLuint shader_type, string source) throws CoreError
	{
		var shader = glCreateShader (shader_type);
		
		if (shader == 0) {
			throw new CoreError.SHADER_INIT ("Cannot allocate shader ID");
		}
		
		string[] sourceArray = { source, null };
		glShaderSource (shader, 1, sourceArray, null);
		glCompileShader (shader);

		GLint compile_ok = GL_FALSE;
		glGetShaderiv (shader, GL_COMPILE_STATUS, out compile_ok);

		if (compile_ok == GL_TRUE)
		{
			return shader;
		}
		
		// Otherwise, there is an error.
		glDeleteShader (shader);
		
		if (shader_type == GL_VERTEX_SHADER) {
			throw new CoreError.SHADER_INIT ("Error compiling vertex shader");
		} else {
			throw new CoreError.SHADER_INIT ("Error compiling fragment shader");
		}
	}
}

}
