library ieee;
use ieee.std_logic_1164.all;
use work.AuxTypes.all;

entity ControlUnit is
  port(RTS     : in  std_logic;
       CTS     : out std_logic;
       c9      : in  std_logic;
       e10c    : out std_logic;
       S       : out std_logic;
       L       : out std_logic;
       Filling : out std_logic;
       SEL     : out std_logic;
       clock   : in  std_logic;
       reset   : in  std_logic);
end entity ControlUnit;

architecture Triple of ControlUnit is

   signal x, InternalCTS: std_logic;
   signal MSMstate: MSMstates;
   
begin

  Two:  entity work.TwoStateMachine(easy)
        port map(MSMstate => MSMstate ,RTS => RTS ,
                 CTS => InternalCTS,
                 clock => clock ,reset => reset);

  CTS <= InternalCTS;
  x <= not(RTS) and InternalCTS;

  Many: entity work.ManyStateMachine(diagram)
	port map(Count => c9, Init => x, 
                 MSMstate => MSMstate,
                 clock => clock, reset => reset);

  Combinational: process(MSMstate)
  begin

     L <= '0';
     e10c <= '1';
     Filling <= '0';
     S <= '0';
     SEL <= '0';

     case MSMstate is
	when Rest =>
	  L <= '1'; e10c <= '0'; Filling <= '1';

	when Stop =>
	  Filling <= '1';
	
	when others => 
	  S <= '1'; SEL <= '1';

       end case;
   end process;
end architecture Triple;
