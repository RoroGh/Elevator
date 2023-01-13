library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
entity final is
   Port (lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clock, reset : in std_logic; 
    motorDir, atlvl0, atlvl1, atlvl2, move, enable, at0, at1, at2, moving : out std_logic );
end final;

architecture Behavioral of final is
signal f0, f1, f2, updown: std_logic;
type state_type is (s0, upA, downA, s1, upB, downB, s2);
signal s: state_type;
signal N, temp, waitLevel: integer:=0;
signal nozero, noone, notwo:std_logic;

begin

transition: process(clock,reset,lvl0in,lvl0out,lvl1in,lvl1out,lvl2in,lvl2out) -- state transition
begin
if ( clock = '1' and clock'event) then
if (reset = '1') then
  s <= s0; f0 <= '0'; f1 <= '0'; f2 <= '0'; N <= 100000000;
else
        if ( (lvl0out = '1'  or lvl0in = '1' ) and nozero = '0' ) then 
                f0 <= '1';
        end if;
        if ( (lvl1out = '1'  or lvl1in = '1' )and noone = '0' ) then
                f1 <= '1';
        end if;
        if ( (lvl2out = '1'  or lvl2in = '1' )and notwo ='0' ) then
                f2 <= '1';
        end if;
        case (s) is
                when s0 =>
                         if ((f1 = '1' or f2 = '1')and waitLevel >= 100000000) then 
                           N <= 100000000; s <= upA ;
                         end if;
                         
                when upA =>
                        if (f1 = '1' and temp=N) then
                          s <= s1; N <= 100000000; f1<='0'; 
                        elsif (f2 = '1' and (f1 = '0') and temp=N) then
                          s <= upB; N <= 100000000;
                        else 
                          s <= upA; N <= 100000000; 
                        end if;

                when downA =>
                        if (temp=N and f0 = '1') then 
                          s<= s0; N <= 100000000; f0<='0';
                        end if;

                when s1 =>
                    if(waitLevel >= 100000000) then
                        if ((f0 = '1' and f2 = '1' and updown = '0') or (f0 = '1' and f2 = '0')) then 
                          s <= downA; N <= 100000000;
                        elsif (( f0 = '0' and f2 = '1' )or( f0 = '1' and f2 = '1' and updown = '1' )) then 
                          s <= upB; N <= 100000000;
                        end if;
                    end if;
                    
                when upB =>
                        if (temp=N and f2 = '1') then 
                          s <= s2; N <= 100000000; f2 <= '0'; 
                        end if;

                when downB =>
                        if (f0 = '1' and f1 = '0' and temp=N) then 
                          s <= downA; N <= 100000000;
                        elsif (f1='1' and temp=N) then 
                          s <= s1; N <= 100000000; f1 <= '0'; 
                        end if;
               
                when s2 =>
                        if ((f1 = '1' or f0 = '1') and waitLevel >= 100000000) then 
                          s <= downB; N <= 100000000;
                        end if;
                end case;              
                end if;
        end if;
end process transition;


 stepper: process(s) ---stepper process
    begin
    case s is
            when s0 =>   updown <= '1'; motorDir<='0'; move <= '1'; enable <= '1'; moving <= '1';
                         atlvl0 <= '1'; atlvl1 <= '0'; atlvl2 <= '0';
                         at0 <= '1'; at1 <= '0'; at2 <= '0';
                         nozero <= '1'; noone <= '0'; notwo <= '0';
            when s1 =>   updown <= updown; motorDir <= '0'; move <= '1'; enable <= '1';moving <= '1';
                         atlvl1 <= '1'; atlvl0 <= '0'; atlvl2 <= '0';
                         at1 <= '1'; at0 <= '0'; at2 <= '0';
                         nozero <= '0'; noone <= '1'; notwo <= '0';
            when s2 =>   updown <= '0';  motorDir <= '0'; move <= '1'; enable <= '1'; moving <= '1';
                         atlvl2 <= '1'; atlvl0 <= '0'; atlvl1 <= '0';
                         at2 <= '1'; at0 <= '0'; at1 <= '0';
                         nozero <= '0'; noone <= '0'; notwo <= '1';
            when upA =>  updown <= '1'; motorDir <= '0'; move <= '0'; enable <= '0'; moving <= '0';
                         atlvl0 <= '0'; atlvl1 <= '0'; atlvl2 <= '0';
                         at0 <= '0'; at1 <= '0'; at2 <= '0';
                         nozero <= '0'; noone <= '0'; notwo <= '0';
            when upB=>   updown <= '1'; motorDir <= '0'; move <= '0'; enable <= '0';moving <= '0';
                         atlvl0 <= '0'; atlvl1 <= '0'; atlvl2 <= '0';
                         at0 <= '0'; at1 <= '0'; at2 <= '0'; 
                         nozero <= '0'; noone <='0'; notwo <= '0';
            when downA=> updown <= '0'; motorDir <= '1'; move <= '0'; enable <= '0';moving <= '0';
                         atlvl0 <= '0'; atlvl1 <= '0'; atlvl2 <= '0';
                         at0 <= '0'; at1 <= '0'; at2 <= '0';
                         nozero <= '0'; noone <= '0'; notwo <= '0';
            when downB=> updown <= '0'; motorDir <= '1';  move <= '0'; enable <= '0';moving <= '0';
                         atlvl0 <= '0'; atlvl1 <= '0'; atlvl2 <= '0';
                         at0 <= '0'; at1 <= '0'; at2 <= '0';
                         nozero <= '0'; noone <= '0'; notwo <= '0';
    end case;    
end process stepper ;

temproc: process(clock)
begin
    if(clock'event and clock='1') then 
            if(s = upA or s = upB or s = downB or s = downA) then 
                temp <= temp+1;
                if(temp = N)then 
                  temp <= 0;
                end if;
            elsif(s = s0 or s = s1 or s = s2) then
                temp <= 0;
            end if;
     end if;
end process;

waitLevelproc: process(clock)
begin
    if(clock'event and clock='1')then 
        if((s = s0 or s = s1 or s = s2) and waitLevel <= 100000000) then 
          waitLevel <= waitLevel + 1;
        elsif(s = upA or s = upB or s = downA or s = downB) then 
          waitLevel <= 0;
        end if;
    end if;
end process;
end Behavioral;