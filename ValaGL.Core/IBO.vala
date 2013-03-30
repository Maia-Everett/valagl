/*
    VBO.vala
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

public class IBO : Object {
	private GLuint id;
	
	public IBO (GLushort[] data) throws CoreError {
		GLuint id_array[1];
		glGenBuffers (1, id_array);
		id = id_array[0];
		
		if (id == 0) {
			throw new CoreError.VBO_INIT ("Cannot allocate index buffer object");
		}
		
		glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, id);
		glBufferData (GL_ELEMENT_ARRAY_BUFFER, data.length * sizeof (GLushort), (GLvoid[]) data, GL_STATIC_DRAW);
		glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, 0);
	}
	
	public void make_current () {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id);
	}
	
	~IBO () {
		if (id != 0) {
			GLuint[] id_array = { id };
			glDeleteBuffers (1, id_array);
		}
	}
}

}
