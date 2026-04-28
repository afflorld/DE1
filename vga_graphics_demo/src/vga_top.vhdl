library ieee;
use ieee.std_logic_1164.all;

entity vga_top is
    port ( 
             clk       : in  std_logic;
             btnc      : in  std_logic;
             btnu      : in  std_logic;
             btnd      : in  std_logic;
             btnl      : in  std_logic;
             btnr      : in  std_logic;
                
             sw        : in  std_logic_vector(15 downto 0);

             vga_xsync : out std_logic;        
             vga_ysync : out std_logic;        
             vga_r     : out std_logic_vector (3 downto 0);
             vga_g     : out std_logic_vector (3 downto 0);
             vga_b     : out std_logic_vector (3 downto 0)
         );
end vga_top;

architecture behavioral of vga_top is

    component clk_en is
        generic ( g_max : positive );
        port (
             clk, rst : in std_logic; 
             ce : out std_logic
        );
    end component;

    component debounce is
        port (
             clk, rst, btn_in : in std_logic; 
             btn_state : out std_logic
        );
    end component;

    component vga_sync is
        port (
             clk, rst, en_25 : in std_logic;
             x_sync, y_sync, video_on : out std_logic;
             x_pos : out integer range 0 to 1023;
             y_pos : out integer range 0 to 511
    );
    end component;

    component fsm is
        port (
             clk, reset, vsync : in std_logic;
             btn_up, btn_down, btn_left, btn_right : in std_logic;
             rect_x : out integer range 0 to 639;
             rect_y : out integer range 0 to 479
    );
    end component;

    component img_gen is
        port (
                 video_on : in std_logic;
                 x_pos    : in integer range 0 to 1023;
                 y_pos    : in integer range 0 to 511;
                 rect_x   : in integer range 0 to 639;
                 rect_y   : in integer range 0 to 479;
                 sw_red   : in std_logic;
                 sw_chess : in std_logic;
                 rgb      : out std_logic_vector(11 downto 0)
             );
    end component;

    signal sig_en_25    : std_logic;
    signal sig_ysync    : std_logic;
    signal sig_video_on : std_logic;

    signal sig_x_pos    : integer range 0 to 1023;
    signal sig_y_pos    : integer range 0 to 511;

    signal sig_rect_x   : integer range 0 to 639;
    signal sig_rect_y   : integer range 0 to 479;

    signal sig_btnu, sig_btnd, sig_btnl, sig_btnr : std_logic;

    signal sig_rgb_full : std_logic_vector(11 downto 0);

begin

    clk_en_0 : clk_en
    generic map ( g_max => 4 )
    port map (
                 clk => clk,
                 rst => btnc,
                 ce  => sig_en_25
             );

    deb_u : debounce 
    port map (
                 clk => clk,
                 rst => btnc,
                 btn_in => btnu,
                 btn_state => sig_btnu
             );
    deb_d : debounce 
    port map (
                 clk => clk,
                 rst => btnc,
                 btn_in => btnd,
                 btn_state => sig_btnd
             );
    deb_l : debounce 
    port map (
                 clk => clk,
                 rst => btnc,
                 btn_in => btnl,
                 btn_state => sig_btnl
             );
    deb_r : debounce 
    port map (
                 clk => clk,
                 rst => btnc,
                 btn_in => btnr,
                 btn_state => sig_btnr
             );

    vga_sync_0 : vga_sync
    port map (
                 clk      => clk,
                 rst      => btnc,
                 en_25    => sig_en_25,
                 x_sync   => vga_xsync,
                 y_sync   => sig_ysync,
                 video_on => sig_video_on,
                 x_pos    => sig_x_pos,
                 y_pos    => sig_y_pos
             );

    vga_ysync <= sig_ysync;

    fsm_0 : fsm
    port map (
                 clk       => clk,
                 reset     => btnc,
                 vsync     => sig_ysync,
                 btn_up    => sig_btnu,
                 btn_down  => sig_btnd,
                 btn_left  => sig_btnl,
                 btn_right => sig_btnr,
                 rect_x    => sig_rect_x,
                 rect_y    => sig_rect_y
             );

    img_gen_0 : img_gen
    port map (
                 video_on => sig_video_on,
                 x_pos    => sig_x_pos,
                 y_pos    => sig_y_pos,
                 rect_x   => sig_rect_x,
                 rect_y   => sig_rect_y,
                 sw_red   => sw(0),
                 sw_chess => sw(15),
                 rgb      => sig_rgb_full
             );

    vga_r <= sig_rgb_full(11 downto 8);
    vga_g <= sig_rgb_full(7 downto 4);
    vga_b <= sig_rgb_full(3 downto 0);

end behavioral;
