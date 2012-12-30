/*
    Camera.vala
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

namespace ValaGL.Core {

public class Camera : Object {
	private Mat4 projection_matrix;
	private Mat4 view_matrix;
	private Mat4 result_matrix;
	private Mat4 total_matrix;
	
	public Camera () {
		reset ();
	}
	
	private void update () {
		result_matrix = projection_matrix;
		result_matrix.mul_mat (ref view_matrix);
	}
	
	public void reset () {
		reset_projection ();
		reset_view ();
	}
	
	public void reset_projection () {
		projection_matrix = Mat4.identity ();
		update ();
	}
	
	public void reset_view () {
		view_matrix = Mat4.identity ();
		update ();
	}
	
	public void apply (GLint uniform_id, ref Mat4 model_matrix) {
		total_matrix = result_matrix;
		total_matrix.mul_mat (ref model_matrix);
		glUniformMatrix4fv (uniform_id, 1, (GLboolean) GL_FALSE, total_matrix.data);
	}
	
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
