


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity clockDiv is
    Port ( clk,move:in std_logic;motorclock: out std_logic);
end clockDiv;

architecture Behavioral of clockDiv is
signal divider:integer:=0;
signal tmp:std_logic;
begin
process(clk)
begin
    if(clk='1' and clk'event) then 
        divider<=divider+1;
        if(divider=50000) then tmp<='1';
        elsif(divider=100000) then tmp<='0';divider<=1;
        end if;
        
    end if;
    if(move<='0')then motorclock<=tmp;
    elsif(move<='1')then motorclock<='0';
    end if;
    --50000
    --100000
end process;

end Behavioral;
