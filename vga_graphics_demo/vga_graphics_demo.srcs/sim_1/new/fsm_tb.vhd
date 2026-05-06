library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fsm is
end tb_fsm;

architecture tb of tb_fsm is

    component fsm
        port (clk       : in  std_logic;
              reset     : in  std_logic;
              vsync     : in  std_logic;
              btn_up    : in  std_logic;
              btn_down  : in  std_logic;
              btn_left  : in  std_logic;
              btn_right : in  std_logic;
              rect_x    : out integer range 0 to 639;
              rect_y    : out integer range 0 to 479);
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal vsync     : std_logic := '0';
    signal btn_up    : std_logic := '0';
    signal btn_down  : std_logic := '0';
    signal btn_left  : std_logic := '0';
    signal btn_right : std_logic := '0';
    signal rect_x    : integer;
    signal rect_y    : integer;

    -- Pomocné signály pre vizualizáciu (ako si chcela xsync/ysync)
    signal xsync_vis : std_logic := '1';
    signal ysync_vis : std_logic := '1';

    constant TbPeriod : time := 10 ns;
    signal TbSimEnded : std_logic := '0';

begin

    dut : fsm
    port map (
        clk       => clk,
        reset     => reset,
        vsync     => vsync,
        btn_up    => btn_up,
        btn_down  => btn_down,
        btn_left  => btn_left,
        btn_right => btn_right,
        rect_x    => rect_x,
        rect_y    => rect_y
    );

    -- Generovanie hodín
    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';
    
    -- Vizualizácia: ysync_vis bude kopírovať náš vsync trigger
    ysync_vis <= not vsync; -- Aby si videla pulzy smerom nadol
    xsync_vis <= not clk;   -- Len aby to v grafe "žilo"

    stimuli : process
    begin
        -- 1. Reset fáza
        reset <= '1';
        wait for 2 * TbPeriod;
        reset <= '0';
        wait for 2 * TbPeriod;

        btn_right <= '1';
        for i in 1 to 5 loop
            vsync <= '1'; wait for 2 * TbPeriod;
            vsync <= '0'; wait for 2 * TbPeriod;
        end loop;
        btn_right <= '0';
        wait for 5 * TbPeriod;

        -- 3. TURBO POHYB DOLE
        btn_down <= '1';
        for i in 1 to 5 loop
            vsync <= '1'; wait for 2 * TbPeriod;
            vsync <= '0'; wait for 2 * TbPeriod;
        end loop;
        btn_down <= '0';
        wait for 5 * TbPeriod;

        btn_left <= '1';
        for i in 1 to 5 loop
            vsync <= '1'; wait for 2 * TbPeriod;
            vsync <= '0'; wait for 2 * TbPeriod;
        end loop;
        btn_left <= '0';
        wait for 5 * TbPeriod;

        btn_up <= '1';
        for i in 1 to 5 loop
            vsync <= '1'; wait for 2 * TbPeriod;
            vsync <= '0'; wait for 2 * TbPeriod;
        end loop;
        btn_up <= '0';

        wait for 100 ns;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
