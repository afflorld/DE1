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

    signal clk      : std_logic := '0';
    signal rst      : std_logic;
    signal en_25    : std_logic := '0';
    signal x_sync   : std_logic;
    signal y_sync   : std_logic;
    signal video_on : std_logic;
    signal x_pos    : integer;
    signal y_pos    : integer;

    constant clk_period : time := 10 ns; 
    signal TbSimEnded   : std_logic := '0';

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

    en_gen : process
    begin
        while TbSimEnded = '0' loop
            en_25 <= '0';
            wait for 3 * clk_period;
            en_25 <= '1';
            wait for clk_period;
        end loop;
        wait;
    end process;

    stimuli : process
    begin
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        
        wait for 20 ms;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;