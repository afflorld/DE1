# Modules

Description of each module used in the design.

## clk_en - Clock Enable module
To drive other logic in the design that requires a slower operation, it is better to generate a clock enable signal (see figure bellow) instead of creating a new clock domain using clock dividers. 
Creating additional clock domains may cause timing issues or clock domain crossing (CDC) problems such as metastability, data loss, and data incoherency.

![image](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab4-counter/images/waveform_clock-enable.png)

Source: https://github.com/tomas-fryza/vhdl-examples/tree/master/lab4-counter

## counter - Counter module
A binary N-bit counter is a digital circuit with N output bits representing the current count value. It counts sequentially from
```Zsh 
0
``` 
to 
```Zsh
2^N-1
```
and then wraps around back to
```Zsh 
0
```
. When the reset signal is asserted, the counter is cleared and starts again from 
```Zsh 
0
```
.
Many digital circuits include an enable (clock enable) input. This signal controls whether the counter is allowed to increment. When the clock enable signal is active (typically high), the counter updates its value on each clock edge and counts normally. When the clock enable signal is inactive (typically low), the counter holds its current value and does not increment.

## debounce - Debounce module

## fsm - Finite State Machine module

## img_gen - Image Generation module

## vga_sync - VGA Synchronization module

