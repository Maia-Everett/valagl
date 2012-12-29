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
using SDLGraphics;

namespace ValaGL {

public class App : GLib.Object {
	private const int DELAY = 10;

	private unowned SDL.Screen screen;
	private GLib.Rand rand;
	private bool done;

	public App () {
		this.rand = new GLib.Rand ();
	}

	public void run () {
		init_video ();

		while (!done) {
			draw ();
			process_events ();
			SDL.Timer.delay (DELAY);
		}
	}

	private void init_video () {
		uint32 video_flags = SurfaceFlag.DOUBLEBUF
							| SurfaceFlag.HWACCEL
							| SurfaceFlag.HWSURFACE
							| SurfaceFlag.FULLSCREEN;

		this.screen = Screen.set_video_mode (0, 0, 32, video_flags);
		
		if (this.screen == null) {
			stderr.printf ("Could not set video mode.\n");
		}

		SDL.WindowManager.set_caption ("Vala SDL Demo", "");
	}

	private void draw () {
		int16 x = (int16) rand.int_range (0, screen.w);
		int16 y = (int16) rand.int_range (0, screen.h);
		int16 radius = (int16) rand.int_range (0, 100);
		uint32 color = rand.next_int ();

		Circle.fill_color (this.screen, x, y, radius, color);
		Circle.outline_color_aa (this.screen, x, y, radius, color);

		this.screen.flip ();
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
		if (event.keysym.sym == KeySymbol.ESCAPE) {
			Event e = Event();
			e.type = EventType.QUIT;
			Event.push(e);
		}
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
