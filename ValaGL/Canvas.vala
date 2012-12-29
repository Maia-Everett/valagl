/*
    Canvas.vala
    Copyright (C) 2012 Maia Kozheva <sikon@ubuntu.com>

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
using GLEW;
using ValaGL.Core;

namespace ValaGL {

private const GLfloat[] triangle_vertices = {
	-0.8f,  0.8f,
	 0.8f,  0.0f,
	-0.8f, -0.8f,
};

public class Canvas : Object {
	private GLProgram gl_program;
	private VBO triangle_vbo;
	private GLint attr_coord2d;
	
	public Canvas () throws AppError {
		// GL initialization comes here
		if (glewInit () != 0) {
			throw new AppError.INIT("Cannot initialize GLEW");
		}
		
		glClearColor (71.0f/255, 95.0f/255, 121.0f/255, 1);
		glEnable (GL_DEPTH_TEST);
		glEnable (GL_BLEND);
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		try {
			gl_program = new GLProgram (Util.data_file_path ("shaders/vertex.glsl"),
										Util.data_file_path ("shaders/fragment.glsl"));
			
			triangle_vbo = new VBO(triangle_vertices);
		} catch (CoreError e) {
			throw new AppError.INIT (e.message);
		}
		
		attr_coord2d = gl_program.get_attrib_location ("coord2d");
	}
	
	public void resize_gl (uint width, uint height) {
		glViewport(0, 0, (GLsizei) width, (GLsizei) height);
	}
	
	public void paint_gl () {
		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		// Activate our vertex and fragment shaders for the next drawing operations
		gl_program.make_current ();
		
		// Draw a simple triangle
		triangle_vbo.make_current ();
		glEnableVertexAttribArray (attr_coord2d);
		glVertexAttribPointer (attr_coord2d, 2, GL_FLOAT, (GLboolean) GL_FALSE, 0, null);
		glDrawArrays (GL_TRIANGLES, 0, 3);
		glDisableVertexAttribArray (attr_coord2d);
	}
}

}
