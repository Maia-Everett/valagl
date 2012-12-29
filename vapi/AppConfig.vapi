/*
    AppConfig.vapi
    Copyright (C) 2010-2012 Maia Kozheva <sikon@ubuntu.com>

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

namespace ValaGL.Core.AppConfig {
	[CCode (cheader_filename = "config.h", cname = "CMAKE_INSTALL_PREFIX")]
	public static const string PREFIX;
	[CCode (cheader_filename = "config.h", cname = "CMAKE_INSTALL_BIN_DIR")]
	public static const string BIN_DIR;
	[CCode (cheader_filename = "config.h", cname = "CMAKE_INSTALL_DATA_DIR")]
	public static const string DATA_DIR;
	[CCode (cheader_filename = "config.h", cname = "CMAKE_INSTALL_APP_DATA_DIR")]
	public static const string APP_DATA_DIR;
	[CCode (cheader_filename = "config.h", cname = "CMAKE_APP_VERSION")]
	public static const string APP_VERSION;
	[CCode (cheader_filename = "config.h", cname = "CMAKE_APP_AUTHORS")]
	public static const string APP_AUTHORS;
}
