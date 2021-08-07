# ValaGL

A skeletal Vala application using modern OpenGL 3.x. No legacy pipeline.

It sets up a fullscreen SDL window and displays a colored rotating cube.

## Building and running under Ubuntu

```
sudo apt-get install libglew-dev libsdl2-dev libgee-0.8-dev cmake valac valadoc
mkdir bin
cd bin; cmake ..; cd ..
make -C bin
bin/valagl
```
