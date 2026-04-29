library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fsm is
end tb_fsm;

architecture tb of tb_fsm is

component fsm
    port (clk       : in  std_logic;
          reset     : in  std_logic;
          vsync     : in  std_logic;
          btn_up    : in  std_logic;
          btn_down  : in  std_logic;
          btn_left  : in  std_logic;
          btn_right : in  std_logic;
          rect_x    : out integer range 0 to 639;
          rect_y    : out integer range 0 to 479);
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

constant TbPeriod : time := 10 ns;
signal TbClock : std_logic := '0';
signal TbSimEnded : std_logic := '0';

begin

dut : fsm
port map (clk       => clk,
          reset     => reset,
          vsync     => vsync,
          btn_up    => btn_up,
          btn_down  => btn_down,
          btn_left  => btn_left,
          btn_right => btn_right,
          rect_x    => rect_x,
          rect_y    => rect_y);

TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
clk <= TbClock;

stimuli : process
begin
    vsync <= '0';
    btn_up <= '0';
    btn_down <= '0';
    btn_left <= '0';
    btn_right <= '0';
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;

    btn_right <= '1';
    vsync <= '1';
    wait for 2 * TbPeriod;
    vsync <= '0';
    wait for 5 * TbPeriod;

    vsync <= '1';
    wait for 2 * TbPeriod;
    vsync <= '0';
    wait for 5 * TbPeriod;

    btn_right <= '0';
    btn_down <= '1';
    vsync <= '1';
    wait for 2 * TbPeriod;
    vsync <= '0';
    wait for 5 * TbPeriod;

    btn_down <= '0';
    btn_up <= '1';
    vsync <= '1';
    wait for 2 * TbPeriod;
    vsync <= '0';
    wait for 5 * TbPeriod;

    wait for 100 ns;
    TbSimEnded <= '1';
    wait;
end process;

end tb;