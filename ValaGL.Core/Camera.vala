/*
    Camera.vala
    Copyright (C) 2013 Maia Kozheva <sikon@ubuntu.com>

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

/**
 * Encapsulates a camera object. A camera contains a projection matrix and a view matrix.
 * 
 * The main purpose of this class is to provide equivalents of legacy OpenGL functions
 * removed in modern OpenGL. Advanced features like quaternion-based rotations are beyond
 * the scope of this project.
*/
public class Camera : Object {
	private Mat4 projection_matrix;
	private Mat4 view_matrix;
	private Mat4 result_matrix;
	private Mat4 total_matrix;
	
	/**
	 * Instantiates a camera object.
	 * 
	 * The projection and view matrices are set to the identity matrix.
	 */
	public Camera () {
		reset ();
	}
	
	private void update () {
		result_matrix = projection_matrix;
		result_matrix.mul_mat (ref view_matrix);
	}
	
	/**
	 * Resets both the projection matrix and the view matrix.
	 */
	public void reset () {
		reset_projection ();
		reset_view ();
	}
	
	/**
	 * Resets the projection matrix, setting it to the identity matrix.
	 */
	public void reset_projection () {
		projection_matrix = Mat4.identity ();
		update ();
	}
	
	/**
	 * Resets the view matrix, setting it to the identity matrix.
	 */
	public void reset_view () {
		view_matrix = Mat4.identity ();
		update ();
	}
	
	/**
	 * Applies the camera to the next model object that will be drawn, by
	 * multiplying the current projection and view matrices by the model matrix
	 * passed to the function (which specifies the offset and rotation of the model
	 * relative to the camera), and binds the matrix data to the specified
	 * shader uniform variable.
	 * 
	 * @param uniform_id The shader uniform variable to bind to
	 * @param model_matrix The model matrix
	 */
	public void apply (GLint uniform_id, ref Mat4 model_matrix) {
		total_matrix = result_matrix;
		total_matrix.mul_mat (ref model_matrix);
		glUniformMatrix4fv (uniform_id, 1, (GLboolean) GL_FALSE, total_matrix.data);
	}
	
	/**
	 * Sets up a perspective projection. The previous projection matrix is ignored and overwritten.
	 * 
	 * Replicates the effects of the legacy ``glFrustum`` function within this camera.
	 * Refer to that function for the complete description of the projection parameters.
	 * 
	 * @param left The coordinate of the left vertical clipping plane.
	 * @param right The coordinate of the right vertical clipping plane.
	 * @param bottom The coordinate of the bottom horizontal clipping plane.
	 * @param top The coordinate of the top horizontal clipping plane.
	 * @param near The coordinate of the near vertical clipping plane. Must be positive.
	 * @param far The coordinate of the far vertical clipping plane. Must be positive.
	 */
	public void set_frustum_projection (GLfloat left, GLfloat right, GLfloat bottom, GLfloat top,
										  GLfloat near, GLfloat far) {
		projection_matrix = Mat4.from_data (
			2f * near / (right - left), 0, (right + left) / (right - left), 0,
			0, 2f * near / (top - bottom), (top + bottom) / (top - bottom), 0,
			0, 0, -(far + near) / (far - near), -2f * far * near / (far - near),
			0, 0, -1, 0
		);
		
		update ();
	}
	
	/**
	 * Sets up a symmetrical perspective projection. The previous projection matrix is ignored and overwritten.
	 * 
	 * Replicates the effects of the legacy ``gluPerspective`` function within this camera.
	 * Refer to that function for the complete description of the projection parameters.
	 * 
	 * @param fovy_deg The field of view angle, in degrees, in the y direction.
	 * @param aspect The aspect ratio that determines the field of view in the x direction.
	 *               The aspect ratio is the ratio of x (width) to y (height).
	 * @param near The coordinate of the near vertical clipping plane. Must be positive.
	 * @param far The coordinate of the far vertical clipping plane. Must be positive.
	 */
	public void set_perspective_projection (GLfloat fovy_deg, GLfloat aspect, GLfloat near, GLfloat far) {
		var f = 1 / Math.tanf (GeometryUtil.deg_to_rad (fovy_deg / 2));
		
		projection_matrix = Mat4.from_data (
			f / aspect, 0, 0, 0,
			0, f, 0, 0,
			0, 0, -(far + near) / (far - near), -2f * far * near / (far - near),
			0, 0, -1, 0
		);
		
		update ();
	}
	
	/**
	 * Sets up an orthogonal projection. The previous projection matrix is ignored and overwritten.
	 * 
	 * Replicates the effects of the legacy ``glOrtho`` function within this camera.
	 * Refer to that function for the complete description of the projection parameters.
	 * 
	 * @param left The coordinate of the left vertical clipping plane.
	 * @param right The coordinate of the right vertical clipping plane.
	 * @param bottom The coordinate of the bottom horizontal clipping plane.
	 * @param top The coordinate of the top horizontal clipping plane.
	 * @param near The coordinate of the near vertical clipping plane.
	 * @param far The coordinate of the far vertical clipping plane.
	 */
	public void set_ortho_projection (GLfloat left, GLfloat right, GLfloat bottom, GLfloat top,
										  GLfloat near, GLfloat far) {
		projection_matrix = Mat4.from_data (
			2f / (right - left), 0, 0, (right + left) / (right - left),
			0, 2f / (top - bottom), 0, (top + bottom) / (top - bottom),
			0, 0, -2f * far * near / (far - near), -(far + near) / (far - near),
			0, 0, 0, 1
		);
		
		update ();
	}
	
	/**
	 * Replicates the effects of the legacy ``gluLookAt`` function within this camera.
	 * Refer to that function for the complete description of how the camera is positioned.
	 * 
	 * @param eye The 3D position of the camera
	 * @param center The 3D position of the point the camera is looking at
	 * @param up The up-direction
	 */
	public void look_at (ref Vec3 eye, ref Vec3 center, ref Vec3 up) {
		Vec3 l = center;
		l.sub (ref eye);
		l.normalize ();
		
		Vec3 uptemp = up;
		uptemp.normalize ();
		
		Vec3 s = l.cross_product (ref uptemp);		
		Vec3 u = s.cross_product (ref l);
		
		view_matrix = Mat4.from_data (
			s.x,  s.y,  s.z,  0,
			u.x,  u.y,  u.z,  0,
			-l.x, -l.y, -l.z, 0,
			0,    0,    0,    1
		);
		
		Vec3 translation = Vec3 ();
		translation.sub (ref eye);
		GeometryUtil.translate (ref view_matrix, ref translation);
		update ();
	}
}

}
