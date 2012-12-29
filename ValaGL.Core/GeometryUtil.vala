/*
    GeometryUtil.vala
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

public class GeometryUtil : Object {
	private GeometryUtil () { }
	
	public static GLfloat deg_to_rad (GLfloat deg) {
		return (GLfloat) (deg * Math.PI / 180f);
	}
	
	public static GLfloat rad_to_deg (GLfloat rad) {
		return (GLfloat) (rad / Math.PI * 180f);
	}
	
	public static void translate (ref Mat4 matrix, ref Vec3 translation) {
		var tmp = Mat4.from_data (
			1, 0, 0, translation.x,
			0, 1, 0, translation.y,
			0, 0, 1, translation.z,
			0, 0, 0, 1
		);
		
		matrix.mul_mat (ref tmp);
	}
	
	public static void scale (ref Mat4 matrix, ref Vec3 scale_factors) {
		var tmp = Mat4.from_data (
			scale_factors.x, 0, 0, 0,
			0, scale_factors.y, 0, 0,
			0, 0, scale_factors.z, 0,
			0, 0, 0, 1
		);
		
		matrix.mul_mat (ref tmp);
	}
	
	public static void rotate (ref Mat4 matrix, GLfloat angle_deg, ref Vec3 axis) {
		Vec3 axis_normalized = axis;
		axis_normalized.normalize ();
		
		GLfloat angle_rad = deg_to_rad (angle_deg);
		
		// M = uuT + (cos a) (1 - uuT) + (sin a) S
		Mat3 tmp1 = Mat3.from_vec_mul (ref axis_normalized, ref axis_normalized);
		Mat3 tmp2 = Mat3.identity ();
		tmp2.sub (ref tmp1);
		tmp2.mul (Math.cosf (angle_rad));
		tmp1.add (ref tmp2);
		
		Mat3 s = Mat3.from_data (
			0, -axis_normalized.z, axis_normalized.y,
			axis_normalized.z, 0, -axis_normalized.x,
			-axis_normalized.y, axis_normalized.x, 0
		);
		s.mul (Math.sinf (angle_rad));
		tmp1.add (ref s);
		
		var tmp = Mat4.expand (ref tmp1);
		matrix.mul_mat (ref tmp);
	}
}

}
