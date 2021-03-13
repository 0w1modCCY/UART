library ieee;
use ieee.std_logic_1164.all;
use work.AuxTypes.all;

entity ManyStateMachine is
  port(Count    : in  std_logic;
       Init     : in  std_logic;
       clock    : in  std_logic;
       reset    : in  std_logic;
       MSMstate : out MSMstates);
end entity ManyStateMachine;

architecture diagram of ManyStateMachine is
    signal present, future: MSMstates;

begin
  Memory: process(clock, reset)
  begin
     if reset = '0' then
	present <= Rest;

     elsif rising_edge(clock) then
	present <= future;
     end if;
  end process;

  Combinational: process(count, init, present)
  begin

     if present=Rest and init='1' then
     future <= Start;
     

     elsif present/=Rest and count='1' then
     future <= NextState(present);

     else future <= present;
     end if;

    MSMstate <= future;
   end process;
end diagram;

