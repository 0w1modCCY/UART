library ieee;
use ieee.std_logic_1164.all;
use work.AuxTypes.all;

entity FSMReceiver is
  port(TxD      : in  std_logic;
       c4       : in  std_logic;
       e10c     : out std_logic;
       received : out std_logic;
       clock    : in  std_logic;
       reset    : in  std_logic);
end entity FSMReceiver;

architecture typical of FSMReceiver is

--Internal Signal
  signal MSMstate: MSMstates; --output of MSM
  signal notTxD: std_logic;

begin
   notTxD <= not(TxD);
   MSTATEM:  entity work.ManyStateMachine(diagram)
        port map(Count => c4 ,Init => notTxD,
                 clock => clock ,reset => reset,
                 MSMstate => MSMstate);
   
  Values: process(MSMstate)
  begin
   if MSMstate=Rest 
      then e10c <= '0';

   elsif MSMstate=Stop 
      then received <= '1';

   else
      e10c <= '1'; 
      received <= '0';
   end if;
  end process;
end architecture typical;	
