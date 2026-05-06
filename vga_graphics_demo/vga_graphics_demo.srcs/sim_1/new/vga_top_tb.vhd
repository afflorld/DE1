library ieee;
use ieee.std_logic_1164.all;

entity tb_vga_top is
end tb_vga_top;

architecture tb of tb_vga_top is

    component vga_top
        port (clk       : in std_logic;
              btnc      : in std_logic;
              btnu      : in std_logic;
              btnd      : in std_logic;
              btnl      : in std_logic;
              btnr      : in std_logic;
              sw        : in std_logic_vector (15 downto 0);
              vga_xsync : out std_logic;
              vga_ysync : out std_logic;
              vga_r     : out std_logic_vector (3 downto 0);
              vga_g     : out std_logic_vector (3 downto 0);
              vga_b     : out std_logic_vector (3 downto 0));
    end component;

    signal clk       : std_logic;
    signal btnc      : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnr      : std_logic := '0';
    signal sw        : std_logic_vector (15 downto 0) := (others => '0');
    signal vga_xsync : std_logic;
    signal vga_ysync : std_logic;
    signal vga_r     : std_logic_vector (3 downto 0);
    signal vga_g     : std_logic_vector (3 downto 0);
    signal vga_b     : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 100 ps; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : vga_top
    port map (clk=>clk, btnc=>btnc, btnu=>btnu, btnd=>btnd, btnl=>btnl, btnr=>btnr, sw=>sw, 
              vga_xsync=>vga_xsync, vga_ysync=>vga_ysync, vga_r=>vga_r, vga_g=>vga_g, vga_b=>vga_b);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        btnc <= '1';
        sw <= x"0000";
        wait for 50 ns;
        btnc <= '0';
        wait for 50 ns;

        sw(15) <= '1'; 
        wait for 200 ns;
        
        sw(15) <= '0'; 
        wait for 150 ns;

        sw(15) <= '1';
        sw(0)  <= '1';
        wait for 150 ns;

      
        btnu <= '1'; wait for 60 ns; btnu <= '0'; wait for 20 ns;
        btnd <= '1'; wait for 60 ns; btnd <= '0'; wait for 20 ns;
        btnl <= '1'; wait for 60 ns; btnl <= '0'; wait for 20 ns;
        btnr <= '1'; wait for 60 ns; btnr <= '0';

        wait for 300 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;
