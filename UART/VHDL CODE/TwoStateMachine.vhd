library ieee;
use ieee.std_logic_1164.all;
use work.AuxTypes.all;

Entity TwoStateMachine is
  port(MSMstate : in MSMstates;
       RTS      : in std_logic;
       CTS      : out std_logic;
       clock    : in std_logic;
       reset    : in std_logic);
end entity TwoStateMachine;

architecture easy of TwoStateMachine is

  type states is (CTS1, CTS0);
  signal present, future: states;
  signal Internal: std_logic;

  begin
  Memory: process(clock, reset)
  begin
     if reset = '0' then
	present <= CTS1;

     elsif rising_edge(clock) then
	present <= future;
     end if;
  end process;

  Combinational: process(MSMstate, RTS, present)
  begin
     if RTS='0' and MSMstate=Rest and present=CTS1
     then future <= CTS0;

     elsif RTS='1' and MSMstate=Rest and present=CTS0
     then future <= CTS1;
     end if;

     if present=CTS1 then CTS <= '1';
     elsif present=CTS0 then CTS <= '0';
     end if;
     
  end process;
end architecture easy;
