library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    constant C_G_BITS : integer := 3;

    component counter
        generic ( G_BITS : positive := 3 );
        port (clk : in std_logic;
              rst : in std_logic;
              en  : in std_logic;
              cnt : out std_logic_vector (G_BITS - 1 downto 0));
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal en  : std_logic;
    signal cnt : std_logic_vector (C_G_BITS - 1 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter
    generic map ( G_BITS => C_G_BITS )
    port map (clk => clk,
              rst => rst,
              en  => en,
              cnt => cnt);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        en  <= '0';
        rst <= '1';
        wait for 35 ns;
        
        rst <= '0';
        wait for TbPeriod;

        en <= '1';
        wait for 15 * TbPeriod;

        en <= '0';
        wait for 5 * TbPeriod;

        en <= '1';
        wait for 10 * TbPeriod;

        rst <= '1';
        wait for 2 * TbPeriod;
        rst <= '0';

        wait for 5 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;
