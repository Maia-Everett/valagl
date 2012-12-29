/*
    Canvas.vala
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
using GLEW;
using ValaGL.Core;

namespace ValaGL {

private const GLfloat[] quad_vertices = {
	-1, -1, 0,
	-1,  1, 0,
	 1,  1, 0,
	 1, -1, 0,
};

public class Canvas : Object {
	private GLProgram gl_program;
	private VBO triangle_vbo;
	private Camera camera;
	private Mat4 model_matrix;
	
	private GLint unif_transform;
	private GLint attr_coord3d;
	
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
			
			triangle_vbo = new VBO(quad_vertices);
		} catch (CoreError e) {
			throw new AppError.INIT (e.message);
		}
		
		unif_transform = gl_program.get_uniform_location ("transform");
		attr_coord3d = gl_program.get_attrib_location ("coord3d");
		
		camera = new Camera();
		Vec3 eye = Vec3.from_data (0, 1, 0);
		Vec3 center = Vec3.from_data (0, 0, -4);
		Vec3 up = Vec3.from_data (0, 1, 0);
		camera.look_at (ref eye, ref center, ref up);
		
		model_matrix = Mat4.identity ();
		
		Vec3 translation = Vec3.from_data (0.5f, 0.5f, -1);
		GeometryUtil.translate (ref model_matrix, ref translation);
	}
	
	public void resize_gl (uint width, uint height) {
		glViewport(0, 0, (GLsizei) width, (GLsizei) height);
		camera.set_perspective_projection (70, (GLfloat) width / (GLfloat) height, 0.01f, 100f);
	}
	
	public void paint_gl () {
		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		// Activate our vertex and fragment shaders for the next drawing operations
		gl_program.make_current ();
		
		// Apply camera before drawing the model
		camera.apply (unif_transform, ref model_matrix);
		
		// Draw a simple triangle
		glEnableVertexAttribArray (attr_coord3d);
		triangle_vbo.apply_as_vertex_array (attr_coord3d, 3);
		glDrawArrays (GL_QUADS, 0, 4);
		glDisableVertexAttribArray (attr_coord3d);
	}
}

}
