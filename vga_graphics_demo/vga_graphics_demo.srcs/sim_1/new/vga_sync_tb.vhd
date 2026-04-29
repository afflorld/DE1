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
          x_pos    : out integer range 0 to 639;
          y_pos    : out integer range 0 to 479);
end component;

signal clk      : std_logic;
signal rst      : std_logic;
signal en_25    : std_logic := '0';
signal x_sync   : std_logic;
signal y_sync   : std_logic;
signal video_on : std_logic;
signal x_pos    : integer;
signal y_pos    : integer;

constant TbPeriod : time := 10 ns;
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

TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
clk <= TbClock;

p_en_gen : process(clk)
    variable count : integer := 0;
begin
    if rising_edge(clk) then
        if rst = '1' then
            count := 0;
            en_25 <= '0';
        else
            if count = 3 then
                en_25 <= '1';
                count := 0;
            else
                en_25 <= '0';
                count := count + 1;
            end if;
        end if;
    end if;
end process;

stimuli : process
begin
    rst <= '1';
    wait for 100 ns;
    rst <= '0';

    wait for 40 ms;

    TbSimEnded <= '1';
    wait;
end process;
end tb;