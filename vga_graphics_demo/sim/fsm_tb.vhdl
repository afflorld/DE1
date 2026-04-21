library ieee;
use ieee.std_logic_1164.all;

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

    signal clk       : std_logic;
    signal reset     : std_logic;
    signal vsync     : std_logic;
    signal btn_up    : std_logic;
    signal btn_down  : std_logic;
    signal btn_left  : std_logic;
    signal btn_right : std_logic;
    signal rect_x    : integer;
    signal rect_y    : integer;

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

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

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        vsync <= '0';
        btn_up <= '0';
        btn_down <= '0';
        btn_left <= '0';
        btn_right <= '0';

        -- Reset generation
        -- ***EDIT*** Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_rect_movement_fsm of tb_rect_movement_fsm is
    for tb
    end for;
end cfg_tb_rect_movement_fsm;