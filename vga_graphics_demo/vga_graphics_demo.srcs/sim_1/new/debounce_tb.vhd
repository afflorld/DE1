library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (clk         : in std_logic;
              rst         : in std_logic;
              btn_in      : in std_logic;
              btn_state   : out std_logic;
              btn_press   : out std_logic;
              btn_release : out std_logic);
    end component;

    signal clk         : std_logic;
    signal rst         : std_logic;
    signal btn_in      : std_logic;
    signal btn_state   : std_logic;
    signal btn_press   : std_logic;
    signal btn_release : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce
    port map (clk         => clk,
              rst         => rst,
              btn_in      => btn_in,
              btn_state   => btn_state,
              btn_press   => btn_press,
              btn_release => btn_release);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        btn_in <= '0';
        rst <= '1';
        wait for 35 ns;
        rst <= '0';
        wait for 20 ns;

        btn_in <= '1'; wait for 12 ns;
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 15 ns;
        btn_in <= '0'; wait for 8 ns;
        btn_in <= '1';
        
        wait for 200 ns;

        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 12 ns;
        btn_in <= '0'; wait for 5 ns;
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0';

        wait for 200 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;