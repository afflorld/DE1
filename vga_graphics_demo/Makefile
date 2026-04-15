# Run this to just build the project files in the background
build:
	vivado -mode batch -source create_proj.tcl

# Run this to build AND open the GUI
gui:
	vivado -source create_proj.tcl

# Run this to just open the already-created project
open:
	vivado ./build/vga_graphics_demo.xpr & 

clean:
	rm -rf build/ .Xil/ *.log *.jou *.str
