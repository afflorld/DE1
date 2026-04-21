library ieee;
use ieee.std_logic_1164.all;

entity tb_vga_sync is
end tb_vga_sync;

architecture tb of tb_vga_sync is

    component vga_sync
        port (clk      : in std_logic;
              rst      : in std_logic;
              en_25    : in std_logic;
              x_sync   : out std_logic;
              y_sync   : out std_logic;
              video_on : out std_logic;
              x_pos    : out integer;
              y_pos    : out integer);
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal en_25    : std_logic;
    signal x_sync   : std_logic;
    signal y_sync   : std_logic;
    signal video_on : std_logic;
    signal x_pos    : integer;
    signal y_pos    : integer;

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : vga_sync
    port map (clk      => clk,
              rst      => rst,
              en_25    => en_25,
              x_sync   => x_sync,
              y_sync   => y_sync,
              video_on => video_on,
              x_pos    => x_pos,
              y_pos    => y_pos);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en_25 <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_vga_sync of tb_vga_sync is
    for tb
    end for;
end cfg_tb_vga_sync;