/*
    Canvas.vala
    Copyright (C) 2013 Maia Everett <maia@everett.one>

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

private const GLfloat[] cube_vertices = {
	// front
	-1, -1,  1,
	1, -1,  1,
	1,  1,  1,
	-1,  1,  1,
	// back
	-1, -1, -1,
	1, -1, -1,
	1,  1, -1,
	-1,  1, -1,
};

private const GLfloat[] cube_colors = {
	// front colors
	1, 0, 0,
	0, 1, 0,
	0, 0, 1,
	1, 1, 1,
	// back colors
	1, 0, 0,
	0, 1, 0,
	0, 0, 1,
	1, 1, 1,
};

private const GLushort cube_elements[] = {
	// front
	0, 1, 2,
	2, 3, 0,
	// top
	1, 5, 6,
	6, 2, 1,
	// back
	7, 6, 5,
	5, 4, 7,
	// bottom
	4, 0, 3,
	3, 7, 4,
	// left
	4, 5, 1,
	1, 0, 4,
	// right
	3, 2, 6,
	6, 7, 3,
};

/**
 * The OpenGL canvas associated with the application main window.
 * 
 * This class is responsible for initializing the state of the OpenGL context
 * and managing resize and redraw events sent by the underlying SDL window.
 */
public class Canvas : Object {
	private GLProgram gl_program;
	private VBO coord_vbo;
	private VBO color_vbo;
	private IBO element_ibo;
	
	private Camera camera;
	private Mat4 model_matrix;
	
	private GLint unif_transform;
	private GLint attr_coord3d;
	private GLint attr_v_color;
	private GLfloat rotation_angle;
	
	/**
	 * Instantiates a new canvas object.
	 * 
	 * Assumes that the desired OpenGL context is already selected.
	 * 
	 * Initializes GLEW, global OpenGL state, and GPU programs that will be
	 * used for rendering.
	 */
	public Canvas () throws AppError {
		// GL initialization comes here
		if (glewInit () != 0) {
			throw new AppError.INIT("Cannot initialize GLEW");
		}
		
		glClearColor (71.0f/255, 95.0f/255, 121.0f/255, 1);
		glEnable (GL_MULTISAMPLE);
		glEnable (GL_DEPTH_TEST);
		glEnable (GL_BLEND);
		glDisable (GL_CULL_FACE);
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		try {
			gl_program = new GLProgram (Util.data_file_path ("shaders/vertex.glsl"),
										Util.data_file_path ("shaders/fragment.glsl"));
			
			coord_vbo = new VBO (cube_vertices);
			color_vbo = new VBO (cube_colors);
			element_ibo = new IBO (cube_elements);
		} catch (CoreError e) {
			throw new AppError.INIT (e.message);
		}
		
		unif_transform = gl_program.get_uniform_location ("transform");
		attr_coord3d = gl_program.get_attrib_location ("coord3d");
		attr_v_color = gl_program.get_attrib_location ("v_color");
		
		camera = new Camera();
		Vec3 eye = Vec3.from_data (0, 2, 0);
		Vec3 center = Vec3.from_data (0, 0, -2);
		Vec3 up = Vec3.from_data (0, 1, 0);
		camera.look_at (ref eye, ref center, ref up);
	}
	
	/**
	 * Handler of the window resize event.
	 * 
	 * It is called for the first time when the SDL window is created and shown,
	 * and then every time the display resolution changes.
	 * 
	 * Responsible for setting up the viewport size and perspective projection.
	 * 
	 * @param width The new window width
	 * @param height The new window height
	 */
	public void resize_gl (uint width, uint height) {
		glViewport(0, 0, (GLsizei) width, (GLsizei) height);
		camera.set_perspective_projection (70, (GLfloat) width / (GLfloat) height, 0.01f, 100f);
	}
	
	/**
	 * Handler of the window repaint event.
	 * 
	 * It is called every time the window is created.
	 * 
	 * Responsible for drawing the OpenGL scene.
	 */
	public void paint_gl () {
		glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
		// Compute current transformation matrix for the cube
		model_matrix = Mat4.identity ();
		
		Vec3 translation = Vec3.from_data (0, 0, -4);
		GeometryUtil.translate (ref model_matrix, ref translation);
		Vec3 rotation = Vec3.from_data (0, 1, 0);
		GeometryUtil.rotate (ref model_matrix, rotation_angle, ref rotation);
		
		// Activate our vertex and fragment shaders for the next drawing operations
		gl_program.make_current ();
		
		// Apply camera before drawing the model
		camera.apply (unif_transform, ref model_matrix);
		
		glEnableVertexAttribArray (attr_coord3d);
		glEnableVertexAttribArray (attr_v_color);
		
		// Apply buffers
		coord_vbo.apply_as_vertex_array (attr_coord3d, 3);
		color_vbo.apply_as_vertex_array (attr_v_color, 3);
		element_ibo.make_current ();
		
		// Draw the cube
		glDrawElements (GL_TRIANGLES, cube_elements.length, GL_UNSIGNED_SHORT, null);
		glDisableVertexAttribArray (attr_coord3d);
		glDisableVertexAttribArray (attr_v_color);
	}
	
	/**
	 * Updates the scene data.
	 * 
	 * In this application, the only variable scene data is the rotation angle.
	 * 
	 * @param rotation_angle The new rotation angle (in degrees)
	 */
	public void update_scene_data(GLfloat rotation_angle) {
		this.rotation_angle = rotation_angle;
	}
}

}
