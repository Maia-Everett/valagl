/*
    MatrixMath.vala
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
 * A 3-component vector.
 */
public struct Vec3 {
	public GLfloat data[3];
	
	/**
	 * Creates a new vector, zero initialized.
	 */
	public Vec3() {
		
	}
	
	/**
	 * Creates a vector whose contents are the copy of the given data.
	 */
	public Vec3.from_data (GLfloat x, GLfloat y, GLfloat z) {
		data[0] = x;
		data[1] = y;
		data[2] = z;
	}
	
	/**
	 * Creates a vector whose contents are the copy of the given array.
	 */
	public Vec3.from_array ([CCode (array_length = false)] GLfloat[] data) {
		this.data[0] = data[0];
		this.data[1] = data[1];
		this.data[2] = data[2];
	}
		
	/**
	 * Adds the given vector, component-wise.
	 */
	public void add (ref Vec3 other) {
		data[0] += other.data[0];
		data[1] += other.data[1];
		data[2] += other.data[2];
	}
	
	/**
	 * Subtracts the given vector, component-wise.
	 */
	public void sub (ref Vec3 other) {
		data[0] -= other.data[0];
		data[1] -= other.data[1];
		data[2] -= other.data[2];
	}
	
	/**
	 * Multiplies the given vector, component-wise.
	 */
	public void mul_vec (ref Vec3 other) {
		data[0] *= other.data[0];
		data[1] *= other.data[1];
		data[2] *= other.data[2];
	}
	
	/**
	 * Divides the given vector, component-wise.
	 */
	public void div_vec (ref Vec3 other) {
		data[0] /= other.data[0];
		data[1] /= other.data[1];
		data[2] /= other.data[2];
	}
	
	/**
	 * Computes the dot product of this vector and the other vector.
	 */
	public GLfloat dot_product (ref Vec3 other) {
		return data[0] * other.data[0] + data[1] * other.data[1] + data[2] * other.data[2];
	}
	
	/**
	 * Computes the cross product of this vector and the other vector.
	 */
	public Vec3 cross_product (ref Vec3 other) {
		return Vec3.from_data(
			data[1] * other.data[2] - data[2] * other.data[1],
			data[2] * other.data[0] - data[0] * other.data[2],
			data[0] * other.data[1] - data[1] * other.data[0]);
	}
	
	/**
	 * Multiplies the vector by the given scalar.
	 */
	public void mul (GLfloat factor) {
		data[0] *= factor;
		data[1] *= factor;
		data[2] *= factor;
	}
	
	/**
	 * Divides the vector by the given scalar.
	 */
	public void div (GLfloat factor) {
		data[0] /= factor;
		data[1] /= factor;
		data[2] /= factor;
	}
	
	/**
	 * Computes the norm of this vector.
	 */
	public GLfloat norm () {
		return Math.sqrtf (dot_product (ref this));
	}

	/**
	 * Normalizes this vector, dividing it by its norm.
	 * If the norm is zero, the result is undefined.
	*/
	public void normalize () {
		div (norm ());
	}
	
	/**
	 * Convenience accessor for data[0].
	 */
	public GLfloat x {
		get { return data[0]; }
	}
	
	/**
	 * Convenience accessor for data[1].
	 */
	public GLfloat y {
		get { return data[1]; }
	}
	
	/**
	 * Convenience accessor for data[2].
	 */
	public GLfloat z {
		get { return data[2]; }
	}
}

/**
 * A 4-component vector.
 */
public struct Vec4 {
	public GLfloat data[4];
	
	/**
	 * Creates a new vector, zero initialized.
	 */
	public Vec4() {
		
	}
	
	/**
	 * Creates a vector whose contents are the copy of the given data.
	 */
	public Vec4.from_data (GLfloat x, GLfloat y, GLfloat z, GLfloat w) {
		data[0] = x;
		data[1] = y;
		data[2] = z;
		data[3] = w;
	}
	
	/**
	 * Creates a vector whose contents are the copy of the given array.
	 */
	public Vec4.from_array ([CCode (array_length = false)] GLfloat[] data) {
		this.data[0] = data[0];
		this.data[1] = data[1];
		this.data[2] = data[2];
		this.data[3] = data[3];
	}
	
	/**
	 * Expands a 3x3 vector plus scalar into a 4x4 vector.
	 */
	public Vec4.expand (ref Vec3 vec3, GLfloat w) {
		this.data[0] = vec3.data[0];
		this.data[1] = vec3.data[1];
		this.data[2] = vec3.data[2];
		this.data[3] = w;
	}
	
	/**
	 * Adds the given vector, component-wise.
	 */
	public void add (ref Vec4 other) {
		data[0] += other.data[0];
		data[1] += other.data[1];
		data[2] += other.data[2];
		data[3] += other.data[3];
	}
	
	/**
	 * Subtracts the given vector, component-wise.
	 */
	public void sub (ref Vec4 other) {
		data[0] -= other.data[0];
		data[1] -= other.data[1];
		data[2] -= other.data[2];
		data[3] -= other.data[3];
	}
	
	/**
	 * Multiplies the given vector, component-wise.
	 */
	public void mul_vec (ref Vec4 other) {
		data[0] *= other.data[0];
		data[1] *= other.data[1];
		data[2] *= other.data[2];
		data[3] *= other.data[3];
	}
	
	/**
	 * Divides the given vector, component-wise.
	 */
	public void div_vec (ref Vec4 other) {
		data[0] /= other.data[0];
		data[1] /= other.data[1];
		data[2] /= other.data[2];
		data[3] /= other.data[3];
	}
	
	/**
	 * Computes the dot product of this vector and the other vector.
	 */
	public GLfloat dot_product (ref Vec4 other) {
		return data[0] * other.data[0] + data[1] * other.data[1]
			 + data[2] * other.data[2] + data[3] * other.data[3];
	}
	
	
	/**
	 * Multiplies the vector by the given scalar.
	 */
	public void mul (GLfloat factor) {
		data[0] *= factor;
		data[1] *= factor;
		data[2] *= factor;
		data[3] *= factor;
	}
	
	/**
	 * Divides the vector by the given scalar.
	 */
	public void div (GLfloat factor) {
		data[0] /= factor;
		data[1] /= factor;
		data[2] /= factor;
		data[3] /= factor;
	}
	
	/**
	 * Computes the norm of this vector.
	 */
	public GLfloat norm () {
		return Math.sqrtf (dot_product(ref this));
	}

	/**
	 * Normalizes this vector, dividing it by its norm.
	 * If the norm is zero, the result is undefined.
	*/
	public void normalize () {
		div (norm ());
	}
	
	/**
	 * Convenience accessor for data[0].
	 */
	public GLfloat x {
		get { return data[0]; }
	}
	
	/**
	 * Convenience accessor for data[1].
	 */
	public GLfloat y {
		get { return data[1]; }
	}
	
	/**
	 * Convenience accessor for data[2].
	 */
	public GLfloat z {
		get { return data[2]; }
	}
	
	/**
	 * Convenience accessor for data[3].
	 */
	public GLfloat w {
		get { return data[3]; }
	}
}

/**
 * A 3x3 matrix.
 */
public struct Mat3 {
	public float data[9];
	
	/**
	 * Creates a new matrix, zero initialized.
	 */
	public Mat3() {
		
	}
	
	/**
	 * Creates a matrix whose contents are the copy of the given data.
	 * Warning: the data are specified in column-first-index order, which is different from
	 * the internal storage format (row-first-index).
	 */
	public Mat3.from_data (GLfloat a11, GLfloat a12, GLfloat a13,
							GLfloat a21, GLfloat a22, GLfloat a23,
							GLfloat a31, GLfloat a32, GLfloat a33) {
		data[0] = a11;
		data[1] = a21;
		data[2] = a31;
		
		data[3] = a12;
		data[4] = a22;
		data[5] = a32;
		
		data[6] = a13;
		data[7] = a23;
		data[8] = a33;
	}
	
	/**
	 * Given two vectors ``a`` and ``b``, computes a matrix equal to ``a * bT``.
	 */
	public Mat3.from_vec_mul (ref Vec3 a, ref Vec3 b) {
		data[0] = a.data[0] * b.data[0];
		data[1] = a.data[1] * b.data[0];
		data[2] = a.data[2] * b.data[0];
		
		data[3] = a.data[0] * b.data[1];
		data[4] = a.data[1] * b.data[1];
		data[5] = a.data[2] * b.data[1];
		
		data[6] = a.data[0] * b.data[2];
		data[7] = a.data[1] * b.data[2];
		data[8] = a.data[2] * b.data[2];
	}
	
	/**
	 * Creates a matrix whose contents are the copy of the given array, assumed to have at least 9 elements.
	 */
	public Mat3.from_array ([CCode (array_length = false)] GLfloat[] data) {
		this.data = data;
	}
	
	/**
	 * Creates an identity matrix.
	 */
	public Mat3.identity () {
		data[0 * 3 + 0] = 1;
		data[1 * 3 + 1] = 1;
		data[2 * 3 + 2] = 1;
	}
		
	/**
	 * Adds the given matrix, component-wise.
	 */
	public void add (ref Mat3 other) {
		for (int i = 0; i < 9; i++) {
			data[i] += other.data[i];
		}
	}
	
	/**
	 * Subtracts the given matrix, component-wise.
	 */
	public void sub (ref Mat3 other) {
		for (int i = 0; i < 9; i++) {
			data[i] -= other.data[i];
		}
	}
	
	/**
	 * Multiplies the matrix by the given scalar, component-wise.
	 */
	public void mul (GLfloat factor) {
		for (int i = 0; i < 9; i++) {
			data[i] *= factor;
		}
	}
	
	/**
	 * Divides the matrix by the given scalar, component-wise.
	 */
	public void div (GLfloat factor) {
		for (int i = 0; i < 9; i++) {
			data[i] /= factor;
		}
	}
	
	/**
	 * Multiplies the given matrix using the linear algebra definition of matrix multiplication.
	 */
	public void mul_mat (ref Mat3 other) {
		float res[9]; // Zero initialized
		
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				res[j * 3 + i] = 0;
				
				for (int k = 0; k < 3; k++) {
					res[j * 3 + i] += data[k * 3 + i] * other.data[j * 3 + k];
				}
			}
		}
		
		data = res;
	}
	
	/**
	 * Multiplies this matrix by the given vector and returns the result as a new vector.
	 */
	public Vec3 mul_vec (ref Vec3 vec) {
		Vec3 res = Vec3(); // Zero initialized
		
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				res.data[i] += data[j * 3 + i] * vec.data[j];
			}
		}
				
		return res;
	}
	
	/**
	 * Returns a new matrix that is the transposition of this matrix.
	 */
	public Mat3 transposed () {
		Mat3 res = Mat3();
		
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				res.data[i * 3 + j] = data[j * 3 + i];
			}
		}
		
		return res;
	}
	
	/**
	 * Computes the determinant of this matrix.
	 */
	public GLfloat det () {
		return det_helper3 (data[0:3], data[3:6], data[6:9]);
	}
	
	/**
	 * Returns a new matrix that is the inversion of this matrix.
	 * @param success Set to ``false`` if the matrix cannot be inverted (its determinant is zero)
	 *                and ``true`` otherwise.
	 * @return The inverted matrix if the matrix was not successfully inverted,
	 *         otherwise the return value is undefined.
	 */
	public Mat3 inverted (out bool success) {
		GLfloat det = det ();
		
		if (Math.fabsf (det) < 0.00001f) {
			success = false;
			return Mat3 ();
		}
		
		success = true;
		
		GLfloat inv_det = 1.0f / det;
		Mat3 res = Mat3 ();
		
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				int i1 = (i + 1) % 3;
				int j1 = (j + 1) % 3;
				int i2 = (i + 2) % 3;
				int j2 = (j + 2) % 3;
				// Warning: computing determinants from transposed matrix! i becomes j and the other way round
				res.data [j * 3 + i] = inv_det *
					(data[i1 * 3 + j1] * data[i2 * 3 + j2] - data[i2 * 3 + j1] * data[i1 * 3 + j2]);
			}
		}
		
		return res;
	}
}

/**
 * A 4x4 matrix.
 */
public struct Mat4 {
	public float data[16];
	
	/**
	 * Creates a new matrix, zero initialized.
	 */
	public Mat4() {
		
	}
	
	/**
	 * Creates a matrix whose contents are the copy of the given data.
	 * Warning: the data are specified in column-first-index order, which is different from
	 * the internal storage format (row-first-index).
	 */
	public Mat4.from_data (GLfloat a11, GLfloat a12, GLfloat a13, GLfloat a14,
							GLfloat a21, GLfloat a22, GLfloat a23, GLfloat a24,
							GLfloat a31, GLfloat a32, GLfloat a33, GLfloat a34,
							GLfloat a41, GLfloat a42, GLfloat a43, GLfloat a44) {
		data[0]  = a11;
		data[1]  = a21;
		data[2]  = a31;
		data[3]  = a41;
		
		data[4]  = a12;
		data[5]  = a22;
		data[6]  = a32;
		data[7]  = a42;
		
		data[8]  = a13;
		data[9]  = a23;
		data[10] = a33;
		data[11] = a43;
		
		data[12] = a14;
		data[13] = a24;
		data[14] = a34;
		data[15] = a44;
	}
	
	/**
	 * Given two vectors ``a`` and ``b``, computes a matrix equal to ``a * bT``.
	 */
	public Mat4.from_vec_mul (ref Vec4 a, ref Vec4 b) {
		data[0]  = a.data[0] * b.data[0];
		data[1]  = a.data[1] * b.data[0];
		data[2]  = a.data[2] * b.data[0];
		data[3]  = a.data[3] * b.data[0];

		data[4]  = a.data[0] * b.data[1];
		data[5]  = a.data[1] * b.data[1];
		data[6]  = a.data[2] * b.data[1];
		data[7]  = a.data[3] * b.data[1];

		data[8]  = a.data[0] * b.data[2];
		data[9]  = a.data[1] * b.data[2];
		data[10] = a.data[2] * b.data[2];
		data[11] = a.data[3] * b.data[2];

		data[12] = a.data[0] * b.data[3];
		data[13] = a.data[1] * b.data[3];
		data[14] = a.data[2] * b.data[3];
		data[15] = a.data[3] * b.data[3];
	}
	
	/**
	 * Creates a matrix whose contents are the copy of the given array, assumed to have at least 16 elements.
	 */
	public Mat4.from_array ([CCode (array_length = false)] GLfloat[] data) {
		this.data = data;
	}
	
	/**
	 * Creates an identity matrix.
	 */
	public Mat4.identity () {
		data[0 * 4 + 0] = 1;
		data[1 * 4 + 1] = 1;
		data[2 * 4 + 2] = 1;
		data[3 * 4 + 3] = 1;
	}
	
	/**
	 * Creates an expansion of the given 3x3 matrix into 4x4:
	 * 
	 * A  0
	 * 
	 * 0  1
	 */
	public Mat4.expand (ref Mat3 mat3) {
		data[0]  = mat3.data[0];
		data[1]  = mat3.data[1];
		data[2]  = mat3.data[2];
		
		data[4]  = mat3.data[3];
		data[5]  = mat3.data[4];
		data[6]  = mat3.data[5];
		
		data[8]  = mat3.data[6];
		data[9]  = mat3.data[7];
		data[10] = mat3.data[8];
		
		data[3 * 4 + 3] = 1;
	}
		
	/**
	 * Adds the given matrix, component-wise.
	 */
	public void add (ref Mat4 other) {
		for (int i = 0; i < 16; i++) {
			data[i] += other.data[i];
		}
	}
	
	/**
	 * Subtracts the given matrix, component-wise.
	 */
	public void sub (ref Mat4 other) {
		for (int i = 0; i < 16; i++) {
			data[i] -= other.data[i];
		}
	}
	
	/**
	 * Multiplies the matrix by the given scalar, component-wise.
	 */
	public void mul (GLfloat factor) {
		for (int i = 0; i < 16; i++) {
			data[i] *= factor;
		}
	}
	
	/**
	 * Divides the matrix by the given scalar, component-wise.
	 */
	public void div (GLfloat factor) {
		for (int i = 0; i < 16; i++) {
			data[i] /= factor;
		}
	}
	
	/**
	 * Multiplies the given matrix using the linear algebra definition of matrix multiplication.
	 */
	public void mul_mat (ref Mat4 other) {
		float res[16]; // Zero initialized
		
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				res[j * 4 + i] = 0;
				
				for (int k = 0; k < 4; k++) {
					res[j * 4 + i] += data[k * 4 + i] * other.data[j * 4 + k];
				}
			}
		}
		
		data = res;
	}
	
	/**
	 * Multiplies this matrix by the given vector and returns the result as a new vector.
	 */
	public Vec4 mul_vec (ref Vec4 vec) {
		Vec4 res = Vec4(); // Zero initialized
		
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				res.data[i] += data[j * 4 + i] * vec.data[j];
			}
		}
		
		return res;
	}
	
	/**
	 * Returns a new matrix that is the transposition of this matrix.
	 */
	public Mat4 transposed () {
		Mat4 res = Mat4();
		
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				res.data[i * 4 + j] = data[j * 4 + i];
			}
		}
		
		return res;
	}
	
	/**
	 * Computes the determinant of this matrix.
	 */
	public GLfloat det () {
		return data[0]  * det_helper3 (data[4:8], data[9:12], data[13:16])
			 - data[4]  * det_helper3 (data[1:4], data[9:12], data[13:16])
			 + data[8]  * det_helper3 (data[1:4], data[4:8],  data[13:16])
			 - data[12] * det_helper3 (data[1:4], data[4:8],  data[9:12] );
	}
	
	/**
	 * Returns a new matrix that is the inversion of this matrix.
	 * @param success Set to ``false`` if the matrix cannot be inverted (its determinant is zero)
	 *                and ``true`` otherwise.
	 * @return The inverted matrix if the matrix was not successfully inverted,
	 *         otherwise the return value is undefined.
	 */
	public Mat4 inverted (out bool success) {
		GLfloat det = det ();
		
		if (Math.fabsf (det) < 0.00001f) {
			success = false;
			return Mat4 ();
		}
		
		success = true;
		
		GLfloat inv_det = 1.0f / det;
		Mat3 transposed_submatrix = Mat3 ();
		Mat4 res = Mat4 ();
		
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				int i1 = (i + 1) % 4;
				int j1 = (j + 1) % 4;
				int i2 = (i + 2) % 4;
				int j2 = (j + 2) % 4;
				int i3 = (i + 3) % 4;
				int j3 = (j + 3) % 4;
				
				// Warning: computing determinants from transposed matrix! i becomes j and the other way round
				transposed_submatrix.data = {
					data[i1 * 4 + j1], data[i1 * 4 + j2], data[i1 * 4 + j3],
					data[i2 * 4 + j1], data[i2 * 4 + j2], data[i2 * 4 + j3],
					data[i3 * 4 + j1], data[i3 * 4 + j2], data[i3 * 4 + j3]
				};
				
				res.data [j * 4 + i] = inv_det * transposed_submatrix.det ();
			}
		}
		
		return res;
	}
}

private static GLfloat det_helper3 ([CCode (array_length = false)] GLfloat[] col1,
									  [CCode (array_length = false)] GLfloat[] col2,
									  [CCode (array_length = false)] GLfloat[] col3) {
	return    col1[0] * (col2[1] * col3[2] - col2[2] * col3[1])
			+ col2[0] * (col3[1] * col1[2] - col3[2] * col1[1])
			+ col3[0] * (col1[1] * col2[2] - col1[2] * col2[1]);
}

}
