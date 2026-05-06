library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_sync is -- Generates horizontal and vertical timing signals for 640x480 display
    Port ( 
             clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             en_25 : in STD_LOGIC;
             x_sync : out STD_LOGIC; -- Horizontal synchronization pulse
             y_sync : out STD_LOGIC; -- Vertical synchronization pulse
             video_on : out STD_LOGIC; -- High when the current pixel is within the visible area
             x_pos : out INTEGER range 0 to 639; -- horizontal pixel position
             y_pos : out INTEGER range 0 to 479 -- vertical pixel position
         );  
end vga_sync;

architecture Behavioral of vga_sync is

    -- There are 800 total pixels in horizontal direction (640 visible + 16 front porch + 96 sync + 48 black porch)
    signal x_cnt : integer range 0 to 799 := 0;
    -- There are 525 total lines in vertical direction (480 visible + 10 front porch + 2 sync + 33 black porch)
    signal y_cnt : integer range 0 to 524 := 0;

begin

    xy_counting: process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then -- reset both counters to the start of the frame
                x_cnt <= 0;
                y_cnt <= 0;
            elsif en_25 = '1' then -- Move horizontally accross the line
                if x_cnt = 799 then
                    x_cnt <= 0; -- reset to the start of the line if it reaches the end
                    if y_cnt = 524 then 
                        y_cnt <= 0;
                    else
                        y_cnt <= y_cnt + 1; -- increment to the next line
                    end if;
                else
                    x_cnt <= x_cnt + 1;
                end if;
            end if;
        end if;
    end process;


    x_sync <= '0' when (x_cnt >= 656 and x_cnt <= 751) else '1'; -- Active low pulse between 656 and 751
    y_sync <= '0' when (y_cnt >= 490 and y_cnt <= 491) else '1'; -- Active low pulse between 490 and 491
    video_on <= '1' when (x_cnt < 640 and y_cnt < 480) else '0'; -- High when within visible area

    x_pos <= x_cnt when (x_cnt < 640) else 0; -- Output pixel coords, reset 0 while blanks
    y_pos <= y_cnt when (y_cnt < 480) else 0;

end Behavioral;