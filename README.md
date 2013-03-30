# ValaGL

A skeletal Vala application using modern OpenGL 3.x. No legacy pipeline.

It sets up a fullscreen SDL window and displays a colored rotating cube.

## Building and running under Ubuntu

```
sudo apt-get install libGLEW-dev libsdl1.2-dev libgee-dev cmake valac valadoc
mkdir bin
cd bin; cmake ..; cd ..
make -C bin
bin/valagl
```
