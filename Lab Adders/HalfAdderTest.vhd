library ieee;
use ieee.std_logic_1164.all;

entity HalfAdderTest is
end entity;

architecture SimpleTest of HalfAdderTest is
  signal inta, intb: std_logic:='0';
  signal ints, intc: std_logic;
  constant lag: time:= 1 ns;
  begin
    TheHalfAdder: entity work.HalfAdder(Flow)
      generic map(delay => lag)
      port map(a => inta, b => intb,
               s => ints, c => intc);

    inta <= not inta after 10*lag;
    intb <= not intb after 20*lag;

  end architecture SimpleTest;
    
  
