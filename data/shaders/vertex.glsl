uniform mat4 transform;
attribute vec3 coord3d;
attribute vec3 v_color;
varying vec3 f_color;

void main(void) {
	gl_Position = transform * vec4(coord3d, 1.0);
	f_color = v_color;
}
