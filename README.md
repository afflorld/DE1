# VGA Graphics Demo
-------
## About

# VGA Graphics Controller (Nexys A7-50T)

## Project Description
This VHDL project implements a VGA controller generating a 640x480 @ 60Hz video signal. It demonstrates VGA synchronization, combinational image generation (static shapes, patterns), and sequential logic for object animation with boundary collision detection.

## Features & Controls

The system displays a colored square on a black background by default. The behavior can be controlled using the onboard push buttons:

* **Default State:** A static square is displayed in the exact center of the monitor.
* **BTNU (Hold):** Displays a full-screen checkerboard pattern. Used to test VGA synchronization and pixel sharpness.
* **BTND (Hold):** Animates the square. The square moves along the X-axis and automatically bounces off the screen edges. Releasing the button pauses the animation at the current position.
* **BTNR (Press):** Resets the square back to its initial center coordinates.

-------
# Schematic
![Schematic](https://github.com/afflorld/DE1/blob/main/img/shcematic_01.png "Schematic")

-------
# Autors
Samuel Adamec<br />
Lukas Benda<br />
Lukas Bartecek<br />
Vladimir Stastny



# .xdc idea
[Constrains](https://github.com/afflorld/DE1/blob/main/vga_graphics_demo/constr/nexys.xdc "Constrain file")
