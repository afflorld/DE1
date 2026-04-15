# Setup variables
set proj_name "vga_graphics_demo"
set my_part "xc7a50tcsg324-1"

# Create the project
create_project $proj_name ./build -part $my_part -force

# Add source files (Flat structure)
set vhdl_files [glob -nocomplain ./src/*.vhd]
if {[llength $vhdl_files] > 0} {
    add_files $vhdl_files
    puts "Found [llength $vhdl_files] VHDL files in src."
}

# Add Simulation and Constraints
set sim_files [glob -nocomplain ./sim/*.vhd]
if {[llength $sim_files] > 0} {
    add_files -fileset sim_1 $sim_files
}

set xdc_files [glob -nocomplain ./constr/*.xdc]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
}

# Refresh hierarchy
update_compile_order -fileset sources_1

# Explicitly set the top module
set_property top vga_top [current_fileset]

start_gui
