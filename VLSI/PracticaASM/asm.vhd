-- PROGRAMA ESTANDAR PARA CARTA FMS Y ASM
-- M.I. BRYAN EMMANUEL ALVAREZ SERNA

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY asm IS
	PORT(
		CLK, E: IN STD_LOGIC;
		S, C, D, U: OUT INTEGER RANGE 0 TO 14;
		T: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE BEAS OF asm IS
	TYPE ESTADOS IS (INICIO, ESTADO1, ESTADO2, ESTADO3, ESTADO4);
	SIGNAL PRESENTE: ESTADOS := INICIO;
	SIGNAL AUX: INTEGER RANGE 0 TO 9999 := 0;

	-- Señales internas para los valores de salida
	SIGNAL S_int, C_int, D_int, U_int: INTEGER RANGE 0 TO 14 := 0;

BEGIN

	-- Asignaciones de señales internas a las salidas
	S <= S_int;
	C <= C_int;
	D <= D_int;
	U <= U_int;

	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CASE PRESENTE IS
				WHEN INICIO =>
					T <= '1';
					C_int <= 0;
					D_int <= 0;
					U_int <= 0;
					S_int <= 14;
					PRESENTE <= ESTADO1;

				WHEN ESTADO1 =>
					T <= '0';
					PRESENTE <= ESTADO2;

				WHEN ESTADO2 =>
					T <= '1';
					IF E = '0' THEN
						PRESENTE <= INICIO;
					ELSE
						PRESENTE <= ESTADO3;
					END IF;

				WHEN ESTADO3 =>
					-- Lógica de conteo
					IF U_int = 9 THEN
						U_int <= 0;
						IF D_int = 9 THEN
							D_int <= 0;
							IF C_int = 9 THEN
								C_int <= 0;
							ELSE
								C_int <= C_int + 1;
							END IF;
						ELSE
							D_int <= D_int + 1;
						END IF;
					ELSE
						U_int <= U_int + 1;
					END IF;

					-- Límite especial
					IF C_int = 1 AND D_int = 2 AND U_int = 5 THEN
						C_int <= 10;
						D_int <= 11;
						U_int <= 12;
						S_int <= 13;
					END IF;

					IF E = '0' THEN
					
						PRESENTE <= ESTADO4;
					ELSE
						PRESENTE <= ESTADO3;
					END IF;

				WHEN ESTADO4 =>
					IF AUX = 9999 THEN
						AUX <= 0;
						PRESENTE <= INICIO;
					ELSE
						AUX <= AUX + 1;
						PRESENTE <= ESTADO4;
					END IF;
			END CASE;
		END IF;
	END PROCESS;

END BEAS;
