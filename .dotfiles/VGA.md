# Modules

Description of each module used in the design.

## clk_en - Clock Enable module
To drive other logic in the design that requires a slower operation, it is better to generate a clock enable signal (see figure bellow) instead of creating a new clock domain using clock dividers. 
Creating additional clock domains may cause timing issues or clock domain crossing (CDC) problems such as metastability, data loss, and data incoherency.

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab4-counter/images/waveform_clock-enable.png)

Source: https://github.com/tomas-fryza/vhdl-examples/tree/master/lab4-counter

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

Source:https://github.com/tomas-fryza/vhdl-examples/tree/master/lab6-debounce

## fsm - Finite State Machine module

## img_gen - Image Generation module

## vga_sync - VGA Synchronization module

