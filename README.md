# BCD-Adder-with-Error-Checking
A VHDL implementation of a BCD adder circuit that can handle values up to 19 and includes error checking for invalid inputs

Constraints
The VHDL code in this project was developed using structural modeling without the use of if else or case statements. The code was synthesized using Quartus Prime, and the pin assignments were made according to the DE-series board template. The following constraints were applied to the design:

The inputs SW7-4 and SW3-0 were used for the inputs X and Y, respectively.
The input SW8 was used for the carry-in.
The outputs of the four-bit adder circuit were connected to the red lights LEDR.
The BCD values of X and Y were displayed on the 7-segment displays HEX5 and HEX3.
The result S1S0 was displayed on HEX1 and HEX0.
An error was indicated by turning on the red light LEDR9 when the input X or Y was greater than nine.
The code was developed without the use of if else or case statements.
These constraints were used to guide the development of the VHDL code and ensure that the resulting design was compatible with the DE-series board.
