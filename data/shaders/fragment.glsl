#version 120
void main(void) {
  gl_FragColor[0] = 0.4;
  gl_FragColor[1] = 0.8;
  gl_FragColor[2] = gl_FragCoord.y / 1000.0;
  gl_FragColor[3] = 1.0 / 49.0 * mod(gl_FragCoord.y, 50);
}
