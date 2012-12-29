/*
    App.vala
    Copyright (C) 2012 Maia Everett <maia@everett.one>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using SDL;

namespace ValaGL {

public class App : GLib.Object {
	private unowned SDL.Screen screen;
	private GLib.Rand rand;
	private bool done;

	public App () {
		this.rand = new GLib.Rand ();
	}

	public void run () {
		done = true;
		init_video ();

		while (!done) {
			process_events ();
			draw ();
		}
	}

	private void init_video () {
		SDL.GL.set_attribute (GLattr.RED_SIZE, 8);
		SDL.GL.set_attribute (GLattr.GREEN_SIZE, 8);
		SDL.GL.set_attribute (GLattr.BLUE_SIZE, 8);
		SDL.GL.set_attribute (GLattr.ALPHA_SIZE, 8);
		SDL.GL.set_attribute (GLattr.DEPTH_SIZE, 24);
		SDL.GL.set_attribute (GLattr.DOUBLEBUFFER, 1);
		
		uint32 video_flags = SurfaceFlag.OPENGL | SurfaceFlag.FULLSCREEN;
		this.screen = Screen.set_video_mode (0, 0, 32, video_flags);
		
		if (this.screen == null) {
			stderr.printf ("Could not set video mode.\n");
			return;
		}

		SDL.WindowManager.set_caption ("Vala SDL Demo", "");
		GL.glClearColor (71.0f/255, 95.0f/255, 121.0f/255, 1);
		
		// Initialization successful if we got here
		done = false;
	}

	private void draw () {
		GL.glClear (GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
		SDL.GL.swap_buffers ();
	}

	private void process_events () {
		Event event;
		while (Event.poll (out event) == 1) {
			switch (event.type) {
			case EventType.QUIT:
				this.done = true;
				break;
			case EventType.KEYDOWN:
				this.on_keyboard_event (event.key);
				break;
			}
		}
	}

	private void on_keyboard_event (KeyboardEvent event) {
		switch (event.keysym.sym) {
		case KeySymbol.ESCAPE:
			on_quit();
			break;
		case KeySymbol.F4:
			if ((event.keysym.mod & KeyModifier.LALT) != 0 || (event.keysym.mod & KeyModifier.RALT) != 0) {
				on_quit();
			}
			
			break;
		case KeySymbol.TAB:
			if ((event.keysym.mod & KeyModifier.LALT) != 0 || (event.keysym.mod & KeyModifier.RALT) != 0) {
				SDL.WindowManager.iconify ();
			}
			
			break;
		default:
			// TODO: Handle other keyboard combinations
			break;
		}
	}
	
	private void on_quit () {
		Event e = Event();
		e.type = EventType.QUIT;
		Event.push(e);
	}

	public static int main (string[] args) {
		SDL.init (InitFlag.VIDEO);

		var app = new App ();
		app.run ();
		SDL.quit ();
		return 0;
	}
}

}
