# Modules
Description of each module used in the design.

## clk_en - Clock Enable module
To drive other logic in the design that requires a slower operation, it is better to generate a clock enable signal (see figure bellow) instead of creating a new clock domain using clock dividers. 
Creating additional clock domains may cause timing issues or clock domain crossing (CDC) problems such as metastability, data loss, and data incoherency.

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab4-counter/images/waveform_clock-enable.png)

Source: https://github.com/tomas-fryza/vhdl-examples/tree/master/lab4-counter

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `clk` | In | `std_logic` | The very fast 100 MHz main system clock from the board |
| `rst` | In | `std_logic` | Reset signal to restart the internal counter |
| `ce` | Out | `std_logic` | Clock enable pulse. It ticks exactly at 25 MHz |


## counter - Counter module
A binary N-bit counter is a digital circuit with N output bits representing the current count value. It counts sequentially from `0` to `2^N-1` and then wraps around back to `0`. When the reset signal is asserted, the counter is cleared and starts again from `0`.

Many digital circuits include an enable (clock enable) input. This signal controls whether the counter is allowed to increment. When the clock enable signal is active (typically high), the counter updates its value on each clock edge and counts normally. When the clock enable signal is inactive (typically low), the counter holds its current value and does not increment.

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab4-counter/images/waveform_counter.png)

Source: https://github.com/tomas-fryza/vhdl-examples/tree/master/lab4-counter

## debounce - Debounce module
A bouncy button, also known as a switch bounce, refers to the phenomenon where the electrical contacts in a mechanical switch make multiple rapid transitions between open and closed states when pressed or released. These transitions typically occur over a period of 1–25 ms.

As a result, a single press may be interpreted by digital logic as multiple presses, which can cause incorrect behavior in digital circuits. Examples of real push buttons are shown below. (Note that the active level of the buttons in these examples is low, while the buttons on the Nexys A7 board may use a different active level.)

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab6-debounce/images/bouncey4.png)

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab6-debounce/images/bouncey6.png)

Source: https://github.com/tomas-fryza/vhdl-examples/tree/master/lab6-debounce

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `btn_in` | In | `std_logic` | The raw electrical signal coming directly from the physical push button |
| `clk` | In | `std_logic` | The main system clock used to time the filtering process |
| `rst` | In | `std_logic` | Asynchronous reset to clear the internal state of the filter |
| `btn_state` | Out | `std_logic` | The stable signal representing a true button press. Safe to use without registering fake multiple clicks |

## fsm - Finite State Machine module
The FSM acts as the "logic brain" of the project, responsible for calculating the rectangle's position and handling user input. To prevent the rectangle from moving at the internal 100 MHz clock speed (which would be too fast to see), the FSM is synchronized with the vsync signal. This ensures the position updates only once per frame, resulting in a smooth 60 Hz movement.

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `btn_down, _left, _right, _up` | In | `std_logic` | Clean button signals used to steer the object or change the animation state |
| `clk` | In | `std_logic` | Main system clock for synchronous logic |
| `reset` | In | `std_logic` | Returns the animated object to its starting position |
| `vsync` | In | `std_logic` | The VSYNC pulse from `vga_sync`. We use this as a slow 60Hz timer so the object moves exactly 1 step per frame, creating smooth animation |
| `rect_x` | Out | `std_logic_vector(9:0)` | The calculated X-coordinate where the object should be right now |
| `rect_y` | Out | `std_logic_vector(8:0)` | The calculated Y-coordinate where the object should be right now |

## img_gen - Image Generation module
This module is a combinational logic block. It determines the final 12-bit RGB color for every pixel based on the current coordinates provided by the synchronization module.

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `btn_u` | In | `std_logic` | Switch to activate the static test pattern - the chessboard |
| `rect_x`, `rect_y` | In | `std_logic_vector` | The target coordinates of our moving object, provided by the FSM brain |
| `video_on` | In | `std_logic` | The safety flag. If this is '0', the module overrides everything and outputs black screen |
| `x_pos`, `y_pos` | In | `std_logic_vector` | The exact pixel the monitor is asking us to color at the moment |
| `rgb` | Out | `std_logic_vector(11:0)` | The final 12-bit color code - 4 bits Red, 4 bits Green, 4 bits Blue that are sent to the screen |

## vga_sync - VGA Synchronization module
Acts as the timing core of the video controller, ensuring that pixels are sent to the monitor in the correct order and at the precise rate required by the VGA standard. It handles the transition from a 1D stream of pixel data into a 2D 640×480 frame.

The module utilizes a nested counter system to track the "scanning" position. The horizontal counter (x_cnt) counts from 0 up to 799, and the vertical counter (y_cnt) increments every time a full row is completed, counting from 0 up to 524. While the total area is 800×525 pixels, only the first 640×480 region is visible. The remaining "non-visible" areas—known as the front porch, sync pulse, and back porch—are used to reset the monitor's timing.

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `clk` | In | `std_logic` | Main system clock |
| `en_25` | In | `std_logic` | The 25 MHz pulse from `clk_en` that drives the pixel counting |
| `rst` | In | `std_logic` | Resets the  horizontal and vertical counters to zero |
| `video_on` | Out | `std_logic` | A safety flag. It is '1' only when the monitor is in the active display area. If it is '0', we must output black to prevent monitor errors |
| `x_pos` | Out | `std_logic_vector(9:0)` | The current horizontal coordinate of the monitor's brush (0 to 639) |
| `x_sync` | Out | `std_logic` | Horizontal sync pulse - HSYNC. Tells the monitor to move the brush to the next line |
| `y_pos` | Out | `std_logic_vector(8:0)` | The current vertical coordinate of the monitor's brush (0 to 479) |
| `y_sync` | Out | `std_logic` | Vertical sync pulse - VSYNC. Tells the monitor to start a completely new frame at the top left |


## Top module 

| Port Name | Direction | Size/Type | Description |
| :--- | :--- | :--- | :--- |
| `clk` | In | `std_logic` | Main system clock for synchronous logic |
| `btn[c/u/d/l/r]` | In | `std_logic` | The physical push-buttons on the board |
| `vga_xsync` | Out | `std_logic` | The physical HSYNC pin wired to the VGA port |
| `vga_ysync` | Out | `std_logic` | The physical VSYNC pin wired to the VGA port |
| `vga_r`, `vga_g`, `vga_b` | Out | `std_logic_vector(3:0)` | The physical pins sending analog color data to the VGA port. |


