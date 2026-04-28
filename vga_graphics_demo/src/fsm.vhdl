library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    Port (
             clk      : in  STD_LOGIC;         
             reset    : in  STD_LOGIC;          
             vsync    : in  STD_LOGIC;           
             btn_up   : in  STD_LOGIC;
             btn_down : in  STD_LOGIC;
             btn_left : in  STD_LOGIC;
             btn_right: in  STD_LOGIC;
             rect_x   : out INTEGER range 0 to 639;
             rect_y   : out INTEGER range 0 to 479
         );
end fsm;

architecture Behavioral of fsm is

    type state_type is (S_IDLE, S_MOVE, S_WAIT);
    signal current_state : state_type := S_IDLE;

    signal x_reg : integer range 0 to 639 := 295; 
    signal y_reg : integer range 0 to 479 := 215; 

    constant RECT_WIDTH  : integer := 50;
    constant RECT_HEIGHT : integer := 50;
    constant SCREEN_W    : integer := 640;
    constant SCREEN_H    : integer := 480;
    constant STEP        : integer := 1; 

begin

    rect_x <= x_reg;
    rect_y <= y_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S_IDLE;
            x_reg <= 295;
            y_reg <= 215;
        elsif rising_edge(clk) then
            case current_state is

                when S_IDLE =>
                    if vsync = '1' then
                        current_state <= S_MOVE;
                    end if;

                when S_MOVE =>
                    if btn_up = '1' and y_reg > 0 then
                        y_reg <= y_reg - STEP;
                    end if;

                    if btn_down = '1' and (y_reg + RECT_HEIGHT) < SCREEN_H then
                        y_reg <= y_reg + STEP;
                    end if;

                    if btn_right = '1' and (x_reg + RECT_WIDTH) < SCREEN_W then
                        x_reg <= x_reg + STEP;
                    end if;

                    if btn_left = '1' and x_reg > 0 then
                        x_reg <= x_reg - STEP;
                    end if;

                    current_state <= S_WAIT;

                when S_WAIT =>
                    if vsync = '0' then
                        current_state <= S_IDLE;
                    end if;

                when others =>
                    current_state <= S_IDLE;
            end case;
        end if;
    end process;

end Behavioral;
