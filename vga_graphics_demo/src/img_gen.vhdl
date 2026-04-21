library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity image_gen is
    Port (
        video_on : in  STD_LOGIC;
        x_pos    : in  integer range 0 to 1023; 
        y_pos    : in  integer range 0 to 511;  
        rect_x   : in  integer range 0 to 639;
        rect_y   : in  integer range 0 to 479;
        btn_u    : in  STD_LOGIC;               
        rgb      : out STD_LOGIC_VECTOR(11 downto 0)
    );
end image_gen;

architecture Behavioral of image_gen is
    constant SQ_SIZE : integer := 50;
begin

    process(x_pos, y_pos, video_on, btn_u, rect_x, rect_y)
        variable bit_x, bit_y, checker : std_logic;
    begin
        bit_x := to_unsigned(x_pos, 10)(5);
        bit_y := to_unsigned(y_pos, 9)(5);
        checker := bit_x xor bit_y;

        if video_on = '0' then
            rgb <= x"000"; 

        elsif btn_u = '1' then
            if checker = '1' then
                rgb <= x"FFF"; 
            else
                rgb <= x"000"; 
            end if;

        elsif (x_pos >= rect_x) and (x_pos < rect_x + SQ_SIZE) and 
              (y_pos >= rect_y) and (y_pos < rect_y + SQ_SIZE) then
            rgb <= x"0F0";

        else
            rgb <= x"000";
        end if;
    end process;
end Behavioral;
