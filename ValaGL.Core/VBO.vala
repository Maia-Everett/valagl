/*
    VBO.vala
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
 * Encapsulation of an OpenGL vertex buffer object.
 * 
 * The underlying OpenGL buffer is destroyed when this object is finally unreferenced.
 */
public class VBO : Object {
	private GLuint id;
	
	/**
	 * Creates a vertex buffer object.
	 * 
	 * @param data Array to bind to the OpenGL buffer
	 */
	public VBO (GLfloat[] data) throws CoreError {
		GLuint id_array[1];
		glGenBuffers (1, id_array);
		id = id_array[0];
		
		if (id == 0) {
			throw new CoreError.VBO_INIT ("Cannot allocate vertex buffer object");
		}
		
		glBindBuffer (GL_ARRAY_BUFFER, id);
		glBufferData (GL_ARRAY_BUFFER, data.length * sizeof (GLfloat), (GLvoid[]) data, GL_STATIC_DRAW);
		glBindBuffer (GL_ARRAY_BUFFER, 0);
	}
	
	/**
	 * Makes this VBO current for future drawing operations in the OpenGL context.
	 */
	public void make_current () {
		glBindBuffer(GL_ARRAY_BUFFER, id);
	}
	
	/**
	 * Makes this VBO current for future drawing operations in the OpenGL context,
	 * and sets it up as the source of vertex data for the given shader attribute.
	 * 
	 * For the meaning of ``attribute`` and ``stride``, see ``glVertexAttribPointer``.
	 * 
	 * @param attribute The index of the generic vertex attribute to be modified.
	 * @param stride The byte offset between consecutive generic vertex attributes.
	 */
	public void apply_as_vertex_array (GLint attribute, GLsizei stride) {
		make_current ();
		glVertexAttribPointer (attribute, stride, GL_FLOAT, (GLboolean) GL_FALSE, 0, null);
	}
	
	~VBO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteBuffers (1, id_array);
		}
	}
}

}
