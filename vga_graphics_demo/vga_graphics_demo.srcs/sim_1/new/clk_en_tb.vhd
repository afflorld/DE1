library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        generic ( G_MAX : positive := 5 );
        port (clk : in std_logic;
              rst : in std_logic;
              ce  : out std_logic);
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal ce  : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clk_en
    generic map (
        G_MAX => 5
    )
    port map (
        clk => clk,
        rst => rst,
        ce  => ce
    );

   
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
    
        rst <= '0';
        wait for 5 ns;

        rst <= '1';
        wait for 25 ns;
        rst <= '0';
        

        wait for 200 ns;

        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait for 500 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;