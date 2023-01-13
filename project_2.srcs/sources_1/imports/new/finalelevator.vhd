library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity finalelevator is
Port ( lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clk, reset : in std_logic;  
motorDir, atlvl0, atlvl1, atlvl2, motorclock, enable, at0, at1, at2, moving : out std_logic);
end finalelevator;

architecture Behavioral of finalelevator is
signal move:std_logic;
component clockDiv is 
Port ( clk, move: in std_logic; motorclock: out std_logic);
end component;
component final is
Port (lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clock, reset : in std_logic; 
    motorDir, atlvl0, atlvl1, atlvl2, move, enable, at0, at1, at2, moving: out std_logic );
end component;
begin
unit1: clockDiv port map(clk,move,motorclock);
unit2: final port map(lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clk, reset,
    motorDir, atlvl0, atlvl1, atlvl2, move, enable, at0, at1, at2, moving);

end Behavioral;