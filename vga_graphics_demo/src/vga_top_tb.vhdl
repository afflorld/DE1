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
              vga_xsync : out std_logic;
              vga_ysync : out std_logic;
              vga_r     : out std_logic_vector (3 downto 0);
              vga_g     : out std_logic_vector (3 downto 0);
              vga_b     : out std_logic_vector (3 downto 0));
    end component;

    signal clk       : std_logic := '0';
    signal btnc      : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnr      : std_logic := '0';
    signal vga_xsync : std_logic;
    signal vga_ysync : std_logic;
    signal vga_r     : std_logic_vector (3 downto 0);
    signal vga_g     : std_logic_vector (3 downto 0);
    signal vga_b     : std_logic_vector (3 downto 0);

    constant clk_period : time := 10 ns; 
    signal TbSimEnded   : std_logic := '0';

begin

    dut : vga_top
    port map (clk       => clk,
              btnc      => btnc,
              btnu      => btnu,
              btnd      => btnd,
              btnl      => btnl,
              btnr      => btnr,
              vga_xsync => vga_xsync,
              vga_ysync => vga_ysync,
              vga_r     => vga_r,
              vga_g     => vga_g,
              vga_b     => vga_b);

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
        btnc <= '1';
        btnu <= '0';
        btnd <= '0';
        btnl <= '0';
        btnr <= '0';
        wait for 100 ns;
        btnc <= '0';
        wait for 100 ns;

        btnr <= '1';
        wait for 1 ms;
        btnr <= '0';
        
        wait for 100 ns;
        
        btnd <= '1';
        wait for 1 ms;
        btnd <= '0';

        wait for 17 ms;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;