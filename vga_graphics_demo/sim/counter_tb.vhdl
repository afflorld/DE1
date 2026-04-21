library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    constant G_BITS : integer := 4;

    component counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            en  : in std_logic;
            cnt : out std_logic_vector (G_BITS - 1 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal en  : std_logic := '0';
    signal cnt : std_logic_vector (G_BITS - 1 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    signal tb_sim_ended : std_logic := '0';

begin

    dut : counter
        port map (
            clk => clk,
            rst => rst,
            en  => en,
            cnt => cnt
        );

    clk_process : process
    begin
        while tb_sim_ended = '0' loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stimuli : process
    begin
        en <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;
        
        en <= '1';
        wait for 100 * CLK_PERIOD;

        tb_sim_ended <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_counter of tb_counter is
    for tb
    end for;
end cfg_tb_counter;