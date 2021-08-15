/*
    App.vala
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

using SDL;
using SDL.Input;
using SDL.Video;

namespace ValaGL {

/**
 * The singleton application, responsible for managing the fullscreen SDL main window.
 */
public class App : GLib.Object {
	private enum EventCode {
		TIMER_EVENT
	}
	
	private Window window;
	private SDL.Video.GL.Context context;
	private bool done;
	private Canvas canvas;
	private SDL.Timer? timer;
	
	private uint initial_rotation_angle = 30;
	private uint timer_ticks;
	
	/**
	 * Creates the application.
	 */
	public App() {
		// Do nothing
	}

	/**
	 * Runs the application.
	 */
	public void run () throws AppError {
		try {
			init_video ();
			init_timer ();

			while (!done) {
				process_events ();
				draw ();
			}
		} finally {
			if (timer != null) {
				timer.remove ();
				timer = null;
			}
			
			// Free the canvas and associated GL resources
			canvas = null;
		}
	}

	private void init_video () throws AppError {
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.RED_SIZE, 8);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.GREEN_SIZE, 8);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.BLUE_SIZE, 8);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.ALPHA_SIZE, 8);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.DEPTH_SIZE, 16);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.DOUBLEBUFFER, 1);

		// Request OpenGL 3.3 core profile
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.CONTEXT_PROFILE_MASK, SDL.Video.GL.ProfileType.CORE);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.CONTEXT_MAJOR_VERSION, 3);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.CONTEXT_MINOR_VERSION, 3);
		
		// Ask for multisampling if possible
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.MULTISAMPLEBUFFERS, 1);
		SDL.Video.GL.set_attribute (SDL.Video.GL.Attributes.MULTISAMPLESAMPLES, 4);
		
		// Enter fullscreen mode.
		window = new Window ("Vala OpenGL Skeletal Application", -1, -1, -1, -1,
				WindowFlags.FULLSCREEN_DESKTOP | WindowFlags.OPENGL);
		
		if (window == null) {
			throw new AppError.INIT ("Could not set video mode");
		}

		context = SDL.Video.GL.Context.create (window);

		if (context == null) {
			throw new AppError.INIT ("Could not create GL context");
		}

		canvas = new Canvas ();
		
		// Get the screen width and height and set up the viewport accordingly
		int width;
		int height;
		window.get_size (out width, out height);
		canvas.resize_gl (width, height);
		canvas.update_scene_data (initial_rotation_angle);
	}
	
	private void init_timer () {
		timer = SDL.Timer (10, (interval) => {
			// Executed in a separate thread, so we exchange information with the UI thread through events
			SDL.Event event = SDL.Event () {
				type = EventType.USEREVENT
			};
			event.user.code = EventCode.TIMER_EVENT;
			Event.push (event);
			return interval;
		});
	}

	private void draw () {
		canvas.paint_gl ();
		SDL.Video.GL.swap_window (window);
	}

	private void process_events () {
		Event event;
		
		while (Event.poll (out event) == 1) {
			switch (event.type) {
			case EventType.QUIT:
				done = true;
				break;
			case EventType.WINDOWEVENT:
				on_window_event (event.window);
				break;
			case EventType.KEYDOWN:
				on_keyboard_event (event.key);
				break;
			case EventType.USEREVENT:
				on_timer_event ();
				break;
			}
		}
	}
	
	private void on_window_event (WindowEvent event) {
		if (event.event == WindowEventType.RESIZED) {
			canvas.resize_gl (event.data1, event.data2);
		}
	}

	private void on_keyboard_event (KeyboardEvent event) {
		switch (event.keysym.sym) {
		case Keycode.ESCAPE:
			// Close on Esc
			on_quit();
			break;
		default:
			// Insert any other keyboard combinations here.
			break;
		}
	}
	
	private void on_timer_event () {
		timer_ticks = (timer_ticks + 1) % 1800;
		canvas.update_scene_data (initial_rotation_angle + timer_ticks / 5.0f);
	}
	
	private void on_quit () {
		Event e = Event () {
			type = EventType.QUIT
		};
		Event.push(e);
	}

	/**
	 * Application entry point.
	 * 
	 * Creates an instance of the ValaGL application and runs the SDL event loop
	 * until the user exits the application.
	 * 
	 * @param args Command line arguments. Ignored.
	 */
	public static int main (string[] args) {
		SDL.init (InitFlag.VIDEO | InitFlag.TIMER);

		try {
			new App ().run ();
		} catch (AppError e) {
			stderr.printf("Fatal error: %s\n", e.message);
			return 1;
		} finally {
			SDL.quit ();
		}
		
		return 0;
	}
}

}
