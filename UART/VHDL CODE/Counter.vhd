library ieee;
use ieee.std_logic_1164.all;

entity Counter is
  port(c4    : out std_logic;
       c9    : out std_logic;
       e10c  : in  std_logic;
       clock : in  std_logic;
       reset : in  std_logic);
end Counter;

architecture Simple of Counter is
  --type states is (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  signal PresentCount, NewCount : integer range 0 to 9;
  
begin
  Memory: process(clock, reset)
  begin
     if reset = '0' then
	PresentCount <= 0;

     elsif rising_edge(clock) then
	PresentCount <= NewCount;
     end if;
  end process;

  Combinational: process(PresentCount, e10c)
  begin
     c4 <= '0';
     c9 <= '0';
    
     case e10c is
	when '1' =>
	  if PresentCount = 4 then 
 	     NewCount <= PresentCount + 1; c4 <= '1';

	  elsif PresentCount = 9 then
	     NewCount <= 0; c9 <= '1';
	  
	  else NewCount <= PresentCount + 1;
	  end if;

	when '0' =>
	  NewCount <= 0;
	
	when others => 
	  NewCount <= 0;

       end case;
     end process;
end Simple;  
