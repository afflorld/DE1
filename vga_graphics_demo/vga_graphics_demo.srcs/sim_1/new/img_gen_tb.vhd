library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_img_gen is
end tb_img_gen;

architecture tb of tb_img_gen is

    component img_gen
        port (video_on  : in  std_logic;
              x_pos     : in  integer range 0 to 1023;
              y_pos     : in  integer range 0 to 511;
              rect_x    : in  integer range 0 to 639;
              rect_y    : in  integer range 0 to 479;
              sw_red    : in  std_logic;
              sw_chess  : in  std_logic;
              rgb       : out std_logic_vector(11 downto 0));
    end component;

    signal video_on  : std_logic := '0';
    signal x_pos     : integer := 0;
    signal y_pos     : integer := 0;
    signal rect_x    : integer := 100;
    signal rect_y    : integer := 100;
    signal sw_red    : std_logic := '0';
    signal sw_chess  : std_logic := '0';
    signal rgb       : std_logic_vector(11 downto 0);

begin

    dut : img_gen
    port map (video_on => video_on, x_pos => x_pos, y_pos => y_pos,
              rect_x => rect_x, rect_y => rect_y,
              sw_red => sw_red, sw_chess => sw_chess, rgb => rgb);

    stimuli : process
    begin
        video_on <= '0'; sw_chess <= '1'; sw_red <= '1';
        x_pos <= 110; y_pos <= 110;
        wait for 100 ns;

        video_on <= '1'; sw_chess <= '1';
        x_pos <= 10; y_pos <= 10;
        wait for 100 ns;
        x_pos <= 40;
        wait for 100 ns;

        sw_chess <= '1'; sw_red <= '0';
        x_pos <= 110; y_pos <= 110;
        wait for 100 ns;

        sw_red <= '1';
        wait for 100 ns;

        x_pos <= 10; y_pos <= 10;
        sw_chess <= '0';
        wait for 100 ns;

        sw_chess <= '1';
        for i in 0 to 5 loop
            x_pos <= i * 32;
            wait for 50 ns;
        end loop;

        wait;
    end process;

end tb;
