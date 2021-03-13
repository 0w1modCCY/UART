library ieee;
use ieee.std_logic_1164.all;

entity emitter is
  port(TxD   : out std_logic;
       DataToSend  : in  std_logic_vector(7 downto 0);
       RTS   : in  std_logic;
       CTS   : out std_logic;
       clock : in  std_logic;
       reset : in  std_logic);
end entity emitter;

architecture Structural of emitter is

   signal c9, C4, e10c, S, Load, SEL, Filling, Shift, SI, SSR: std_logic;
   --signal EightBO: std_logic_vector(7 downto 0);

begin

   COUNT10:  entity work.Counter(Simple)
        port map(c4 => c4 ,c9 => c9 , e10c => e10c,
                 clock => clock ,reset => reset);

   c4 <= '0';
  
   CONTROL:  entity work.ControlUnit(Triple)
        port map(RTS => RTS, CTS => CTS, c9 => c9,
                 e10c => e10c, S => S, L => Load,
                 Filling => Filling, SEL => SEL,
                 clock => clock, reset => reset);

   Shift <= c9 and S;
 
   SHIFTER:  entity work.ShiftRegister(Typical)
        port map(EightBitsIn => DataToSend, EightBitsOut => open,
                 clock => clock, reset => reset, Load => Load,
                 Shift => Shift, SerialIn => SI, SerialOut => SSR); 

   SI <= '1';

   MUX2TO1: process(SSR, Filling, SEL)
      begin
         if SEL = '1' then TxD <= Filling;
         else TxD <= SSR;
         end if;
      end process;
end Structural;
