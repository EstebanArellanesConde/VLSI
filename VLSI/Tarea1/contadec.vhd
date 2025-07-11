LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY contadec IS
    PORT(
        CLK, RST, ENB: IN STD_LOGIC;
        M, C, D, U: BUFFER INTEGER RANGE 0 TO 9 -- Agregar centenas y millares
    );
END ENTITY;

ARCHITECTURE BEAS OF contadec IS
BEGIN
    PROCESS(CLK)
    BEGIN
        IF FALLING_EDGE (CLK) THEN
            IF RST = '1' THEN
                M <= 9;
                C <= 9;
                D <= 9;
                U <= 9;
            ELSIF ENB = '1' THEN
                IF U = 0 THEN
                    U <= 9;
                    IF D = 0 THEN
                        D <= 9;
                        IF C = 0 THEN
                            C <= 9;
                            IF M = 0 THEN
                                M <= 9; -- Reiniciar en 9999
                            ELSE
                                M <= M - 1;
                            END IF;
                        ELSE
                            C <= C - 1;
                        END IF;
                    ELSE
                        D <= D - 1;
                    END IF;
                ELSE
                    U <= U - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END BEAS;
