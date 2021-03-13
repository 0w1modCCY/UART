-- Victor Moreno Arribas
-- Jorge Albendea Pizarro

library IEEE;
use IEEE.std_logic_1164.all;

entity Bitslice is
  generic(delay : time := 0 ns);
  port(
    -- The control signals:
    CT     : in  std_logic_vector(5 downto 0);
    -- The data bits to be operated on:
    Abit  : in  std_logic;
    Bbit  : in  std_logic;
    -- The input carry to the bitslice:
    Cbit  : in  std_logic;
    -- The output result:
    Rbit  : out std_logic;
    -- The output carry for the next stage:
    Cout : out std_logic);
end BitSlice;

architecture Simple of BitSlice is

signal Mux4, Xg, Fsum: std_logic;
signal D: std_logic_vector(1 downto 0);

begin
Mux: entity work.Mux4times1(algorithmic)
generic map(delay => delay)
port map(
	Data => CT(3 downto 0),
	Sel1 => Abit,
	Sel0 => Bbit,
	OutMux => Mux4);

Xg <= CT(4) xor Bbit after delay;

Full: entity work.FullAdder(WithHalfAdders)
generic map(delay => delay)
port map(
	a => Xg,
	b => Abit,
	c => Cbit,
	sum => Fsum,
	carry => Cout);

D(1) <= Fsum and CT(5) after delay;
D(0) <= Mux4 and not CT(5) after delay;
Rbit <= D(0) or D(1) after delay;
end architecture;
