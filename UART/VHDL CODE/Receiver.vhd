library ieee;
use ieee.std_logic_1164.all;


entity Receiver is
  port(TxD      : in  std_logic;
       Data     : out std_logic_vector(7 downto 0);
       Received : out std_logic;
       clock    : in  std_logic;
       reset    : in  std_logic);
end entity Receiver;


architecture Functional of Receiver is

-- This is a simple algorithmic architecture. It only checks for the reset at the beginning of
-- the process. This is not a great limitation, because we are only going to activate it at the
-- initial moment.
 
begin

process
begin
if reset /= '1' then
  Data <= "00000000";
  received <= '0';
  wait until reset = '1';
else
  wait until rising_edge(clock) and TxD = '0';
  for CuentaCiclos in 0 to 14 loop
     wait until rising_edge(clock);
  end loop;
  Data(0) <= TxD;
  for i in 1 to 7 loop
     for CycleCount in 0 to 9 loop   
        wait until rising_edge(clock);
     end loop;
   Data(i) <= TxD;        
   end loop;
   received <= '1';
   for CycleCount in 0 to 9 loop
      wait until rising_edge(clock);
   end loop;
   received <= '0';   
end if;
end process;

end architecture Functional;

architecture Structural of Receiver is

   --Internal signals
   signal Load, SO, c4, c9, e10c: std_logic;
   signal EI: std_logic_vector(7 downto 0);

begin

   COUNT10:  entity work.Counter(Simple)
        port map(c4 => c4 ,c9 => c9 , e10c => e10c,
                 clock => clock ,reset => reset);

   c9 <= '0'; --We don't need this signal's value

   SHIFTER:  entity work.ShiftRegister(Typical)
        port map(EightBitsIn => EI, EightBitsOut => Data,
                 clock => clock, reset => reset, Load => Load,
                 Shift => c4, SerialIn => TxD, SerialOut => SO); 

   --Same thing with this ones
   EI <= "00000000";
   Load <= '0';
   SO   <= '0';

   FSM_REC:  entity work.FSMReceiver(typical)
        port map(TxD => TxD, c4 => c4, e10c => e10c, received => Received,
                 clock => clock, reset => reset);
  
end Structural;          
