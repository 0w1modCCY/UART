library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
  port(EightBitsIn : in  std_logic_vector(7 downto 0);
       EightBitsOut: out std_logic_vector(7 downto 0);
       clock       : in  std_logic;
       reset       : in  std_logic;
       Load        : in  std_logic;
       Shift       : in  std_logic;
       SerialIn    : in  std_logic;
       SerialOut   : out std_logic);
end ShiftRegister;

architecture Typical of ShiftRegister is
    signal RegValue, FutRegValue, allCeros : std_logic_vector(7 downto 0);
    signal shiftLoad : std_logic_vector(1 downto 0);
begin
  allCeros <= "00000000";

  Memory: process(clock, reset)
  begin
     if reset = '0' then
	RegValue <= allCeros;

     elsif rising_edge(clock) then
	RegValue <= FutRegValue;
     end if;
  end process;

  Output: process(RegValue)
  begin
     EightBitsOut <= RegValue;
     SerialOut    <= RegValue(0);
  end process;

  Combinational: process(shift, load, EightBitsIn, SerialIn, RegValue)
  begin
     shiftLoad(0) <= shift;
     shiftLoad(1) <= load;
 
     case shiftLoad is
	when "00" =>
	  FutRegValue <= RegValue;
       
        when "01" =>
          FutRegValue <= SerialIn & RegValue(7 downto 1);

        when "10" =>
          FutRegValue <= EightBitsIn;

        when "11" =>
          FutRegValue <= allCeros;
   
        when others => FutRegValue<="XXXXXXXX";

     end case;
  end process;  
end architecture Typical;
