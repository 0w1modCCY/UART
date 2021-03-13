-- Victor Moreno Arribas
-- Jorge Albendea Pizarro

library ieee;
use ieee.std_logic_1164.all;

entity HalfAdder is
  generic (delay : time := 0 ns);
  port(a, b : in  std_logic;
       s, c : out std_logic);
end entity;

architecture Flow of HalfAdder is

begin
	s <= a xor b after delay;
	c <= a and b after delay; 

end architecture;
