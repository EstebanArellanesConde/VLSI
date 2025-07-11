LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CaF IS 
	PORT(CUENTAS: IN integer range 0 to 4095;
		  UNIT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	     C, D, U: OUT integer range 0 to 9;
		  FSM: IN STD_LOGIC);
END ENTITY;

ARCHITECTURE BEAS OF CaF IS
	SIGNAL TC, TF, Vx, UC, DC, CC, UF, DF, CF: INTEGER RANGE 0 TO 4095;

BEGIN
	
	Vx <= (5 * CUENTAS) / 4095;
	TC <=100*Vx;
	TF <= (9 * TC) / 5 + 32;
	
	 UC <= Vx mod 10;
    DC <= (Vx / 10) mod 10;
    CC <= (Vx / 100) mod 10;
    
    UF <= TF mod 10;
    DF <= (TF / 10) mod 10;
    CF <= (TF / 100) mod 10;
	
--	UC <= TC mod 10;                 -- Unidades (correcto)
--	DC <= (TC / 10) mod 10;          -- Decenas
--	CC <= (TC / 100) mod 10;         -- Centenas
--
--	UF <= TF mod 10;                 -- Unidades
--	DF <= (TF / 10) mod 10;          -- Decenas
--	CF <= (TF / 100) mod 10;         -- Centenas
	
	PROCESS(CUENTAS, FSM)
	BEGIN
		 
		 IF FSM = '0' THEN
			 C<=CC; D<=DC; U<=UC;
			 UNIT<="11000110";--C
		 ELSE
			 C<=CF; D<=DF; U<=UF;
			 UNIT<="10001110";--F
		 END IF;
		 
	END PROCESS;

END BEAS;