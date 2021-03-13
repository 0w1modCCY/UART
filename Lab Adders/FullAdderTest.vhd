library ieee;
use ieee.std_logic_1164.all;

entity FullAdderTest is
end entity;

architecture TestSums of FulladderTest is
  signal a, b, c: std_logic:='0';
  signal sum, carry: std_logic;
  constant lag: time:= 1 ns;
  begin
    TheFullAdder: entity work.FullAdder(WithHalfAdders)
      generic map(delay => lag)
      port map(a => a, b => b, c=> c,
               sum => sum, carry => carry);

    a <= not a after 10*lag;
    b <= not b after 20*lag;
    c <= not c after 40*lag;

    end architecture testSums;
    
  
