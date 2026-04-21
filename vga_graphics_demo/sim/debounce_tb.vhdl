library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (clk           : in std_logic;
              rst           : in std_logic;
              btn_in        : in std_logic;
              btn_state     : out std_logic;
              btn_press     : out std_logic;
              btn_release   : out std_logic);
    end component;

    signal clk           : std_logic := '0';
    signal rst           : std_logic;
    signal btn_in        : std_logic := '0';
    signal btn_state     : std_logic;
    signal btn_press     : std_logic;
    signal btn_release   : std_logic;

    constant clk_period  : time := 20 ns;
    signal TbSimEnded    : std_logic := '0';

begin

    dut : debounce
    port map (clk           => clk,
              rst           => rst,
              btn_in        => btn_in,
              btn_state     => btn_state,
              btn_press     => btn_press,
              btn_release   => btn_release);

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

    stimuli : process
    begin
        rst <= '1';
        btn_in <= '0';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';
        wait for 50 ns;
        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';
        wait for 100 ns;

        btn_in <= '1';
        wait for 30 ms; 
        
        btn_in <= '0';
        wait for 50 ns;
        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';
        
        wait for 30 ms;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;