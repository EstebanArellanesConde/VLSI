LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  -- Asegúrate de usar esta librería para la conversión

ENTITY contadec IS
    PORT(
        RST, ENB, CLK_MST: IN STD_LOGIC;  -- RST y ENB para reset y habilitar
        MIN_U, MIN_D: BUFFER INTEGER RANGE 0 TO 9;  -- Unidades y decenas (como salidas)
        SEG_U, SEG_D: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Display de 7 segmentos para unidades y decenas
        DIG: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Para el multiplexado de 2 dígitos
    );
END ENTITY;

ARCHITECTURE BEAS OF contadec IS
    SIGNAL FREC: INTEGER := 24999999;  -- Frecuencia para el reloj lento
    SIGNAL AUX: INTEGER RANGE 0 TO FREC;  -- Contador auxiliar para el reloj
    SIGNAL CLK: STD_LOGIC;  -- Reloj lento generado
    SIGNAL DIG_SEL: INTEGER RANGE 0 TO 1 := 0; -- Selector de dígitos (0 para MIN_D, 1 para MIN_U)
    SIGNAL SEG_U_INTERNAL, SEG_D_INTERNAL: STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Señales internas para los displays
BEGIN

    -- Generación de un reloj más lento basado en el reloj maestro (CLK_MST)
    PROCESS(CLK_MST)
    BEGIN 
        IF RISING_EDGE(CLK_MST) THEN
            IF AUX = 0 THEN
                CLK <= NOT CLK;
                AUX <= FREC - 1;  -- Reiniciar AUX a FREC - 1
            ELSE
                AUX <= AUX - 1;
            END IF;
        END IF;
    END PROCESS;

    -- Lógica de control del contador con RST y ENB
    PROCESS(CLK, RST, ENB)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF RST = '1' THEN
                MIN_U <= 9;  -- Reset a 99:99
                MIN_D <= 9;
            ELSIF ENB = '1' THEN
                -- Si ENB está activo, el contador sigue decrementando
                IF MIN_U = 0 AND MIN_D = 0 THEN
                    NULL;  -- El contador se detiene al llegar a 00:00
                ELSE
                    IF MIN_U = 0 THEN
                        MIN_U <= 9;
                        IF MIN_D > 0 THEN
                            MIN_D <= MIN_D - 1;  -- Decrementar las decenas
                        END IF;
                    ELSE
                        MIN_U <= MIN_U - 1;  -- Decrementar las unidades
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Asignación de segmentos para las unidades y las decenas (solo un lugar donde asignar valores)
    PROCESS(MIN_U, MIN_D)
    BEGIN
        -- Asignación de segmentos para las unidades (MIN_U)
        CASE MIN_U IS
            WHEN 0 => SEG_U_INTERNAL <= "00000011"; -- 0
            WHEN 1 => SEG_U_INTERNAL <= "10011111"; -- 1
            WHEN 2 => SEG_U_INTERNAL <= "00100101"; -- 2
            WHEN 3 => SEG_U_INTERNAL <= "00001101"; -- 3
            WHEN 4 => SEG_U_INTERNAL <= "10011001"; -- 4
            WHEN 5 => SEG_U_INTERNAL <= "01001001"; -- 5
            WHEN 6 => SEG_U_INTERNAL <= "01000001"; -- 6
            WHEN 7 => SEG_U_INTERNAL <= "00011111"; -- 7
            WHEN others => SEG_U_INTERNAL <= "11111111"; -- Apagar todos los segmentos
        END CASE;

        -- Asignación de segmentos para las decenas (MIN_D)
        CASE MIN_D IS
            WHEN 0 => SEG_D_INTERNAL <= "00000011"; -- 0
            WHEN 1 => SEG_D_INTERNAL <= "10011111"; -- 1
            WHEN 2 => SEG_D_INTERNAL <= "00100101"; -- 2
            WHEN 3 => SEG_D_INTERNAL <= "00001101"; -- 3
            WHEN 4 => SEG_D_INTERNAL <= "10011001"; -- 4
            WHEN 5 => SEG_D_INTERNAL <= "01001001"; -- 5
            WHEN 6 => SEG_D_INTERNAL <= "01000001"; -- 6
            WHEN 7 => SEG_D_INTERNAL <= "00011111"; -- 7
            WHEN others => SEG_D_INTERNAL <= "11111111"; -- Apagar todos los segmentos
        END CASE;
    END PROCESS;

    -- Multiplexación de los dígitos (Muestra las decenas o las unidades)
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF DIG_SEL = 0 THEN
                DIG <= "01";  -- Mostrar decenas
                SEG_D <= SEG_D_INTERNAL; -- Asigna los segmentos de las decenas
                DIG_SEL <= 1;
            ELSE
                DIG <= "10";  -- Mostrar unidades
                SEG_U <= SEG_U_INTERNAL; -- Asigna los segmentos de las unidades
                DIG_SEL <= 0;
            END IF;
        END IF;
    END PROCESS;

END BEAS;
