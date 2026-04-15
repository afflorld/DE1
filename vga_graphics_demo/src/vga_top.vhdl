library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_top is
    Port ( 
        clk : in STD_LOGIC;
        dummy_out : out STD_LOGIC 
    );
end vga_top;

architecture Behavioral of vga_top is
begin
    dummy_out <= clk; -- Just to give it something to do
end Behavioral;

