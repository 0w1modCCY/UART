library IEEE;
-- Victor Moreno Arribas
-- Jorge Albendea Pizarro

use IEEE.std_logic_1164.all;

entity Mux4times1 is
  generic(delay : time := 0 ns);
  port(
    Data   : in  std_logic_vector(3 downto 0);
    Sel1   : in  std_logic;
    Sel0   : in  std_logic;
    OutMux : out std_logic);
end entity Mux4times1;


architecture algorithmic of Mux4times1 is
begin
monje: process(Data, Sel1, Sel0)

variable Internal: std_logic_vector(1 downto 0);

begin
Internal:=(Sel1 & Sel0);

case(Internal) is
	when "00" => OutMux <= Data(0) after delay;
	when "01" => OutMux <= Data(1) after delay;
	when "10" => OutMux <= Data(2) after delay;
	when "11" => OutMux <= Data(3) after delay;
	when others => OutMux <= 'X' after delay;
end case;
end process;
end architecture;


