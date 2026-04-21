library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_sync is
    Port ( 
             clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             en_25 : in STD_LOGIC;
             hsync : out STD_LOGIC;
             vsync : out STD_LOGIC;
             video_on : out STD_LOGIC;
             x_pos : out INTEGER range 0 to 639;
             y_pos : out INTEGER range 0 to 479
         );  
end vga_sync;

architecture Behavioral of vga_sync is

    signal x_cnt : integer range 0 to 799 := 0;
    signal y_cnt : integer range 0 to 524 := 0;

begin

    xy_counting: process (clk) is

    begin

        if rising_edge(clk) then
            if rst = '1' then

                x_cnt <= 0;
                y_cnt <= 0;

            elsif en_25 = '1' then
                if x_cnt = 799 then

                    y_cnt <= 0;

                    if x_cnt = 524 then
                        x_cnt <= 0;
                    else
                        x_cnt <= x_cnt + 1;
                    end if;

                else
                    x_cnt <= x_cnt + 1;
                end if;
            end if;
        end if;
    end process;


    x_pos <= x_cnt when (x_cnt < 640) else 0;
    y_pos <= y_cnt when (y_cnt < 480) else 0;

end Behavioral;

