library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity top_level is
    port (
        SW : in  std_logic_vector(8 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0);
        HEX5 : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of top_level is
    type segment_array is array (0 to 9) of std_logic_vector(6 downto 0);

    signal X, Y : std_logic_vector(3 downto 0);
    signal A : std_logic_vector(3 downto 0);
    signal out_mux : std_logic_vector(3 downto 0);
    signal temp_sum : std_logic_vector(4 downto 0);
    signal Cin   : std_logic;
    signal Sum   : std_logic_vector(3 downto 0);
    signal Sum_5bit   : std_logic_vector(4 downto 0);
    signal Cout1, Cout2, Cout3, Cout4  : std_logic;
    signal S1S0  : std_logic_vector(7 downto 0);
    signal error9, error10, error15 : std_logic;
    signal d0 : std_logic_vector(6 downto 0);
	signal d1 : std_logic_vector(6 downto 0);
    signal d3 : std_logic_vector(6 downto 0);
	signal d5 : std_logic_vector(6 downto 0);

    constant segments : segment_array := (
            "1000000", "1111001", -- 0, 1
            "0100100", "0110000", -- 2, 3
            "0011001", "0010010", -- 4, 5
            "0000010", "1111000", -- 6, 7
            "0000000", "0010000"  -- 8, 9
    );

begin

    X    <= SW(7 downto 4);
    Y    <= SW(3 downto 0);
    Cin  <= SW(8);
    

    adder_1: entity work.adder_bcd 
    port map (
        A    => X(0),
        B    => Y(0),
        Cin  => SW(8),
        Sum  => Sum(0),
        Cout => Cout1
    );

    adder_2: entity work.adder_bcd 
    port map (
        A    => X(1),
        B    => Y(1),
        Cin  => Cout1,
        Sum  => Sum(1),
        Cout => Cout2
    );

    adder_3: entity work.adder_bcd 
    port map (
        A    => X(2),
        B    => Y(2),
        Cin  => Cout2,
        Sum  => Sum(2),
        Cout => Cout3
    );

    adder_4: entity work.adder_bcd 
    port map (
        A    => X(3),
        B    => Y(3),
        Cin  => Cout3,
        Sum  => Sum(3),
        Cout => Cout4
    );

    Sum_5bit <= Cout4 & Sum;

    process(SW,Sum_5bit)
    begin
    -- Check if the sum (X + Y + Cin) >= 10
    error10 <= (NOT(Sum(3) XOR '1') AND Sum(2)) OR (NOT(Sum(3) XOR '1') AND NOT(Sum(2) XOR '0') AND Sum(1));
    -- Check if the sum (X + Y + Cin) > 15
    error15 <= Cout4 OR error10;
    --check if X or Y is greater than 9
    error9 <= ((NOT(X(3) XOR '1') AND X(2)) OR (NOT(X(3) XOR '1') AND NOT(X(2) XOR '0') AND X(1))) 
    OR ((NOT(Y(3) XOR '1') AND Y(2)) OR (NOT(Y(3) XOR '1') AND NOT(Y(2) XOR '0') AND Y(1)));

    temp_sum <= std_logic_vector(unsigned(Sum_5bit) - 10);
    A <= temp_sum(3 downto 0);
    
    end process;


    with error15 select 
        out_mux <=  A when '1',
                   Sum when '0',
                   (others => '0') when others;
    
    d0 <= segments(to_integer(unsigned(out_mux)));
    d1 <= segments(0) when error15 = '0' else segments(1);
    d3 <= segments(to_integer(unsigned(Y)));
    d5 <= segments(to_integer(unsigned(X)));

    HEX0 <= d0;
    HEX1 <= d1;
    HEX3 <= d3;
    HEX5 <= d5;  

    --LED lights connected to the output
    LEDR(9) <= error9;
    LEDR(4) <= Cout4;
    LEDR(3) <= Sum(3);
    LEDR(2) <= Sum(2);
    LEDR(1) <= Sum(1);
    LEDR(0) <= Sum(0);

end architecture;
