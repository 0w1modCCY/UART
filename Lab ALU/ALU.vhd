library IEEE;
-- Victor Moreno Arribas
-- Jorge Albendea Pizarro

use IEEE.std_logic_1164.all;

entity ALU is
  generic(delay : time     := 0 ns;
          N     : positive := 1);
  port(
    -- The control signals:
    CT        : in  std_logic_vector(5 downto 0);
    -- The data words on which the ALU operates:
    A        : in  std_logic_vector(N -1 downto 0);
    B        : in  std_logic_vector(N -1 downto 0);
    -- The initial carry:
    Cinitial      : in  std_logic;
    -- The output result word:
    R        : out std_logic_vector(N -1 downto 0);
    -- The final carry:
    Cfinal     : out std_logic;
    -- And of course the overflow:
    overflow : out std_logic);
end ALU;

architecture Structural of ALU is

signal C: std_logic_vector(0 to N);
signal aux: std_logic;

begin
BSchain: for I in 0 to N-1 generate
	begin
	BS: entity work.BitSlice(Simple)
	generic map(delay => delay)
	port map(
		CT => CT,
		Abit => A(I),
		Bbit => B(I),
		Cbit => C(I),
		Cout => C(I+1),
		Rbit => R(I));
end generate;

C(0) <= Cinitial;
Cfinal <= C(N);
aux <= C(N) xor C(N-1) after delay;
Overflow <= aux and CT(5) after delay;

end architecture;

