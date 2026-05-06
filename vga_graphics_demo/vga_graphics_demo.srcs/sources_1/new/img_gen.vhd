library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity img_gen is
    Port (
             video_on   : in  STD_LOGIC; -- High when current pixel is in the visible area and low during blanking intervals
             x_pos      : in  integer range 0 to 1023; -- Horizontal scan pos
             y_pos      : in  integer range 0 to 511; -- Vertical scan pos
             rect_x     : in  integer range 0 to 639; -- X coordinate of the rectangle
             rect_y     : in  integer range 0 to 479; -- Y coordinate of the rectangle
             sw_red     : in  STD_LOGIC; -- Switch colors of the rectangle
             sw_chess   : in  STD_LOGIC; -- Switch background to a pattern
             rgb        : out STD_LOGIC_VECTOR(11 downto 0) -- 4R, 4G, 4B
         );
end img_gen;

architecture Behavioral of img_gen is
    constant SQ_SIZE : integer := 50;
begin

    process(x_pos, y_pos, video_on, sw_red, sw_chess, rect_x, rect_y)
        variable bit_x, bit_y, checker : std_logic;
    begin
        -- Logic for chess pattern
        bit_x := to_unsigned(x_pos, 10)(5); -- The 10 means we have area of 2^10 and the 5 means every 2^5 bits a bit flips from 0 to 1 thats how we get the pattern
        bit_y := to_unsigned(y_pos, 9)(5);
        checker := bit_x xor bit_y; -- This gives us the alternating pattern

        if video_on = '0' then -- During blanking intervals, output black
            rgb <= x"000"; 

            -- We check if the current scan position is within the rectangle boundaries
            elsif (x_pos >= rect_x) and (x_pos < rect_x + SQ_SIZE) and 
              (y_pos >= rect_y) and (y_pos < rect_y + SQ_SIZE) then


            if sw_red = '1' then -- To change colors
                rgb <= x"F00"; -- Red rectangle
            else
                rgb <= x"0F0"; -- Green rectangle
            end if;

        else 

            -- Renders the chess pattern 
            if sw_chess = '1' then
                if checker = '1' then
                    rgb <= x"FFF"; -- White squares 
                else
                    rgb <= x"000"; -- Black squares
                end if;
            else
                rgb <= x"000"; 
            end if;

        end if;
    end process;
end Behavioral;
