library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rect_movement_fsm is
end tb_rect_movement_fsm;

architecture tb of tb_rect_movement_fsm is

    component rect_movement_fsm
        port (clk       : in std_logic;
              reset     : in std_logic;
              vsync     : in std_logic;
              btn_up    : in std_logic;
              btn_down  : in std_logic;
              btn_left  : in std_logic;
              btn_right : in std_logic;
              rect_x    : out integer;
              rect_y    : out integer);
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic;
    signal vsync     : std_logic := '0';
    signal btn_up    : std_logic := '0';
    signal btn_down  : std_logic := '0';
    signal btn_left  : std_logic := '0';
    signal btn_right : std_logic := '0';
    signal rect_x    : integer;
    signal rect_y    : integer;

    constant clk_period : time := 20 ns;
    signal TbSimEnded   : std_logic := '0';

begin

    dut : rect_movement_fsm
    port map (clk       => clk,
              reset     => reset,
              vsync     => vsync,
              btn_up    => btn_up,
              btn_down  => btn_down,
              btn_left  => btn_left,
              btn_right => btn_right,
              rect_x    => rect_x,
              rect_y    => rect_y);

    clk_process : process
    begin
        while TbSimEnded = '0' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    vsync_process : process
    begin
        while TbSimEnded = '0' loop
            vsync <= '0';
            wait for 10 * clk_period;
            vsync <= '1';
            wait for clk_period;
        end loop;
        wait;
    end process;

    stimuli : process
    begin
        reset     <= '1';
        btn_up    <= '0';
        btn_down  <= '0';
        btn_left  <= '0';
        btn_right <= '0';
        
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        btn_right <= '1';
        wait for 500 ns;
        btn_right <= '0';
        
        wait for 200 ns;

        btn_down <= '1';
        wait for 500 ns;
        btn_down <= '0';

        btn_up   <= '1';
        btn_left <= '1';
        wait for 500 ns;
        btn_up   <= '0';
        btn_left <= '0';

        wait for 1000 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;