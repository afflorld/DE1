library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity image_gen is
    Port (
        clk      : in  STD_LOGIC;
        video_on : in  STD_LOGIC;
        x_pos    : in  integer range 0 to 1023; 
        y_pos    : in  integer range 0 to 511;  
        btn_u    : in  STD_LOGIC;               
        btn_d    : in  STD_LOGIC;              
        btn_r    : in  STD_LOGIC;              
        rgb      : out STD_LOGIC_VECTOR(11 downto 0)
    );
end image_gen;

architecture Behavioral of image_gen is

    -- Konstanty čtverce a obrazovky
    constant SQ_SIZE : integer := 64;
    constant X_MAX   : integer := 640;
    constant SQ_Y    : integer := 208; 

    
    signal sq_x  : integer range 0 to 1023 := (X_MAX - SQ_SIZE) / 2;
    signal dir_x : std_logic := '1';     

    signal frame_tick : std_logic;

begin


    frame_tick <= '1' when (x_pos = 0 and y_pos = 0) else '0';

        process(clk)
    begin
        if rising_edge(clk) then
            if btn_r = '1' then
                sq_x  <= (X_MAX - SQ_SIZE) / 2;
                dir_x <= '1';
                
            elsif btn_d = '1' and frame_tick = '1' then
                if dir_x = '1' then
                    if sq_x >= (X_MAX - SQ_SIZE - 2) then
                        dir_x <= '0';
                    else
                        sq_x <= sq_x + 2; 
                    end if;
                else
                    if sq_x <= 2 then
                        dir_x <= '1';
                    else
                        sq_x <= sq_x - 2;
                    end if;
                end if;
            end if;
        end if;
    end process;

        process(x_pos, y_pos, video_on, btn_u, sq_x)
        variable bit_x, bit_y, checker : std_logic;
    begin
              bit_x := to_unsigned(x_pos, 10)(5);
        bit_y := to_unsigned(y_pos, 9)(5);
        checker := bit_x xor bit_y;

        if video_on = '0' then
            rgb <= x"000"; -- POVINNÁ TMA: Blanking interval
            
        elsif btn_u = '1' then
            
            if checker = '1' then
                rgb <= x"FFF"; -- Bílá
            else
                rgb <= x"000"; -- Černá
            end if;
            
        elsif (x_pos >= sq_x) and (x_pos < sq_x + SQ_SIZE) and 
              (y_pos >= SQ_Y) and (y_pos < SQ_Y + SQ_SIZE) then
           
            rgb <= x"0F0"; 
            
        else
         
            rgb <= x"000"; -- Černá
        end if;
    end process;

end Behavioral;