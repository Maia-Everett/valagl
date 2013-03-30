/*
    Util.vala
    Copyright (C) 2010-2013 Maia Kozheva <sikon@ubuntu.com>

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

namespace ValaGL.Core {

/**
 * Static helper class for miscellaneous utilities essential to the application.
 */
public class Util : GLib.Object {
	private Util () {}
	
	private static bool first_run = true;
	private static bool local_install;
	
	/**
	 * Checks if the application is being run from the root of the build directory.
	 * 
	 * This implementation is rather hackish. It checks for the existence of
	 * a specific source file, as GLib provides no way to get the application
	 * executable directory.
	 */
	public static bool is_local_install () {
		if (first_run) {
			local_install = FileUtils.test ("ValaGL/App.vala", FileTest.EXISTS);
			first_run = false;
		}
		
		return local_install;
	}
	
	private static string get_data_dir () {
		if (is_local_install ())
			return "data";
		
		return AppConfig.APP_DATA_DIR;
	}
	
	/**
	 * Merges the application resources path with the specified relative path.
	 * 
	 * If ``is_local_install`` is true, the application resources path is simply
	 * the ``data`` subdirectory of the build directory. Otherwise, it is the data
	 * installation directory specified at build time.
	 * 
	 * @param rel_path The relative path of the resource in the resource directory
	 */
	public static string data_file_path (string rel_path) {
		return Path.build_filename (get_data_dir (), rel_path);
	}
}

}
