library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
  generic (delay : time := 0 ns);
  port (a, b, c    : in  std_logic;
        sum, carry : out std_logic);
end entity;

architecture WithGates of FullAdder is

signal intA, intB, intC: std_logic;

begin
	intA <= a xor b after delay;
	intB <= c and intA after delay;
	intC <= b and a after delay;
	sum <= intA xor c after delay;
	carry <= intB or intC after delay;

end WithGates;

architecture WithHalfAdders of FullAdder is

signal aux1, aux2, aux3: std_logic;

begin
First: entity work.HalfAdder(Flow)
	generic map(delay => delay)
	port map(b => a, a => b,
		s => aux2, c => aux1);

Second: entity work.HalfAdder(Flow)
	generic map(delay => delay)
	port map(a => c, b => aux2,
		s => sum, c =>aux3);
	
	carry <= aux3 or aux1 after delay;
end WithHalfAdders;
