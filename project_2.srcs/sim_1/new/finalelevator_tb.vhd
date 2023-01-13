library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

entity finalelevator_tb is
end finalelevator_tb;

architecture behavior of finalelevator_tb is

component finalelevator
     Port (lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clk, reset : in std_logic; 
      motorDir, atlvl0, atlvl1, atlvl2, motorclock, enable, at0, at1, at2 : out std_logic );
  end component;

  signal lvl0out, lvl1out, lvl2out, lvl0in, lvl1in, lvl2in, clk, reset: std_logic;
  signal motorDir, atlvl0, atlvl1, atlvl2, motorclock, enable, at0, at1, at2: std_logic ;
  
begin

  uut: finalelevator port map ( lvl0out  => lvl0out,
                        lvl1out  => lvl1out,
                        lvl2out  => lvl2out,
                        lvl0in   => lvl0in,
                        lvl1in   => lvl1in,
                        lvl2in   => lvl2in,
                        clk    => clk,
                        reset    => reset,
                        motorDir => motorDir,
                        atlvl0   => atlvl0,
                        atlvl1   => atlvl1,
                        atlvl2   => atlvl2,
                        motorclock => motorclock,
                        enable   => enable,
                        at0      => at0,
                        at1      => at1,
                        at2      => at2 );

  stimulus: process
  begin
     lvl0in <= '0'; lvl1in <= '0'; lvl2in <= '0'; 
     lvl0out <= '0'; lvl1out <= '0'; lvl2out <= '0';
     reset <= '1'; wait for 30 ms;
     reset <= '0'; wait for 30 ms;
     lvl1in <= '1'; wait for 30 ms;
     lvl1in <= '0'; wait for 2000 ms; 
     lvl2out <= '1'; wait for 30 ms;
     lvl2out <= '0'; wait for 2300 ms;
     reset <= '1'; wait for 30 ms;
     reset <= '0'; wait;
  end process;

  clock: process
  begin
      clk <= '0', '1' after 5 ns; -- clock_period / 2
      wait for 10 ns; -- clock_period
  end process;

end;