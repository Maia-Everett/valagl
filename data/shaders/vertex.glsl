uniform mat4 transform;
attribute vec3 coord3d;

void main(void) {
	gl_Position = transform * vec4(coord3d, 1.0);
}
