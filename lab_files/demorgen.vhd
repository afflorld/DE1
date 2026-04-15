library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity demorgen is
PORT (  a      : in std_logic;
        b      : in std_logic;
        c      : in std_logic;
        f_org  : out std_logic;
        f_nand : out std_logic;
        f_nor  : out std_logic 
      );


end demorgen;

architecture Behavioral of demorgen is

begin

    f_org <= (a and not(b)) or (not(a and c));
    f_nand <=  b nand c;
    f_nor <= ((b nor b) nor (c nor c))nor((b nor b)nor(c nor c));
    
    
end Behavioral;
