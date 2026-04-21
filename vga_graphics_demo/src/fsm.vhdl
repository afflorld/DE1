library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rect_movement_fsm is
    Port (
        clk      : in  STD_LOGIC;           -- Systémový hodiny (napr. 100 MHz)
        reset    : in  STD_LOGIC;           -- Asynchrónny reset
        vsync    : in  STD_LOGIC;           -- Vertikálna synchronizácia z VGA
        -- Debounced tlačidlá
        btn_up   : in  STD_LOGIC;
        btn_down : in  STD_LOGIC;
        btn_left : in  STD_LOGIC;
        btn_right: in  STD_LOGIC;
        -- Výstupné súradnice
        rect_x   : out INTEGER range 0 to 639;
        rect_y   : out INTEGER range 0 to 479
    );
end rect_movement_fsm;

architecture Behavioral of rect_movement_fsm is
    -- Definícia stavov FSM
    type state_type is (S_IDLE, S_MOVE, S_WAIT);
    signal current_state : state_type := S_IDLE;

    -- Vnútorné registre pre súradnice
    signal x_reg : integer range 0 to 639 := 100; -- Štartovacia pozícia X
    signal y_reg : integer range 0 to 479 := 100; -- Štartovacia pozícia Y
    
    -- Konštanty pre rozmery obdĺžnika a obrazovky
    constant RECT_WIDTH  : integer := 50;
    constant RECT_HEIGHT : integer := 50;
    constant SCREEN_W    : integer := 640;
    constant SCREEN_H    : integer := 480;
    constant STEP        : integer := 1; -- Rýchlosť pohybu (pixely za snímok)

begin

    -- Priradenie registrov na výstupy
    rect_x <= x_reg;
    rect_y <= y_reg;

    -- Proces FSM
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S_IDLE;
            x_reg <= 100;
            y_reg <= 100;
        elsif rising_edge(clk) then
            case current_state is

                -- S_IDLE: Čakáme na začiatok VSYNC impulzu
                when S_IDLE =>
                    if vsync = '1' then
                        current_state <= S_MOVE;
                    end if;

                -- S_MOVE: Vyhodnotenie pohybu (vykoná sa len raz za snímok)
                when S_MOVE =>
                    -- Pohyb HORE
                    if btn_up = '1' and y_reg > 0 then
                        y_reg <= y_reg - STEP;
                    end if;
                    
                    -- Pohyb DOLE
                    if btn_down = '1' and (y_reg + RECT_HEIGHT) < SCREEN_H then
                        y_reg <= y_reg + STEP;
                    end if;

                    -- Pohyb VPRAVO
                    if btn_right = '1' and (x_reg + RECT_WIDTH) < SCREEN_W then
                        x_reg <= x_reg + STEP;
                    end if;

                    -- Pohyb VĽAVO
                    if btn_left = '1' and x_reg > 0 then
                        x_reg <= x_reg - STEP;
                    end if;

                    current_state <= S_WAIT;

                -- S_WAIT: Čakáme, kým VSYNC klesne na '0', aby sme necyklili v MOVE
                when S_WAIT =>
                    if vsync = '0' then
                        current_state <= S_IDLE;
                    end if;

                when others =>
                    current_state <= S_IDLE;
            end case;
        end if;
    end process;

end Behavioral;
