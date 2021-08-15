/*
    VBO.vala
    Copyright (C) 2013, 2021 Maia Everett <maia@everett.one>

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
 * Encapsulation of an OpenGL vertex array object.
 * 
 * The underlying OpenGL vertex array is destroyed when this object is finally unreferenced.
 */
public class VAO : Object {
	private GLuint id;
	
	/**
	 * Creates a vertex array object.
	 */
	public VAO () throws CoreError {
		GLuint id_array[1];
		glGenVertexArrays(1, id_array);
		id = id_array[0];

		if (id == 0) {
			throw new CoreError.VBO_INIT ("Cannot allocate vertex array object");
		}
	}

	/**
	 * Registers a VBO binding to the given shader attribute in this VAO.
	 */
	public void register_vbo (VBO vbo, GLint attribute, GLsizei stride) {
		make_current ();
		vbo.make_current ();
		glVertexAttribPointer (attribute, stride, GL_FLOAT, (GLboolean) GL_FALSE, 0, null);
	}
	
	/**
	 * Makes this VAO current for future drawing operations in the OpenGL context.
	 */
	public void make_current () {
		glBindVertexArray(id);
	}
	
	~VAO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteVertexArrays (1, id_array);
		}
	}
}

}
