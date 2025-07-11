LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd IS
	PORT(NUMERO: IN INTEGER RANGE 0 TO 9;
	       SAL: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END bcd;

ARCHITECTURE BEAS OF bcd IS
BEGIN
	
	WITH NUMERO SELECT
		 SAL <= "11111001" WHEN 1, -- 1
				  "10100100" WHEN 2, -- 2
				  "10110000" WHEN 3, -- 3
				  "10011001" WHEN 4, -- 4
				  "10010010" WHEN 5, -- 5
				  "10000010" WHEN 6, -- 6
				  "11111000" WHEN 7, -- 7
				  "10000000" WHEN 8, -- 8
				  "10010000" WHEN 9, -- 9
				  "11000000" WHEN 0, -- 0
				  "11111111" WHEN OTHERS; -- Apaga todo si la entrada no es válida 
	
END BEAS;
