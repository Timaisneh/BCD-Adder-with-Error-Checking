library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adder_bcd is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Sum : out  STD_LOGIC);
end adder_bcd;

architecture Behavioral of adder_bcd is
begin
    Cout <= (A and B) or (A and Cin) or (B and Cin);
    Sum <= A xor B xor Cin;
end Behavioral;