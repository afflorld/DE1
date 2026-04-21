library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        port (
            clk : in std_logic;
            rst : in std_logic;
            ce  : out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal ce  : std_logic;

    constant CLK_PERIOD : time := 10 ns;
    signal tb_sim_ended : std_logic := '0';

begin

    dut : clk_en
        port map (
            clk => clk,
            rst => rst,
            ce  => ce
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
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        wait for 1000 * CLK_PERIOD;

        tb_sim_ended <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_clk_en of tb_clk_en is
    for tb
    end for;
end cfg_tb_clk_en;