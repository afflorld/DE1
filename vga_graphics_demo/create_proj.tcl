# Detect the absolute path of the script directory
set script_dir [file dirname [file normalize [info script]]]

# Set project variables
set proj_name "vga_graphics_demo"
set my_part "xc7a50tcsg324-1"
set build_dir "$script_dir/build"

# Create the project in the build folder
create_project $proj_name $build_dir -part $my_part -force

# Add VHDL source files from the /src directory
set vhdl_files [glob -nocomplain "$script_dir/src/*.vhd*"]
if {[llength $vhdl_files] > 0} {
    add_files $vhdl_files
    puts "--> Found [llength $vhdl_files] VHDL files in src."
}

# Add Simulation files from the /sim directory
set sim_files [glob -nocomplain "$script_dir/sim/*.vhd*"]
if {[llength $sim_files] > 0} {
    add_files -fileset sim_1 $sim_files
}

# Add Constraint files (.xdc) from the /constr directory
set xdc_files [glob -nocomplain "$script_dir/constr/*.xdc"]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
}

# Refresh the hierarchy and explicitly set the Top Module
update_compile_order -fileset sources_1
set_property top vga_top [current_fileset]
update_compile_order -fileset sources_1


start_gui
