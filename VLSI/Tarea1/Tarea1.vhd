LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Tarea1 IS
    PORT(
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        ENB : IN STD_LOGIC;
        SEG_D : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        SEG_U : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCTURAL OF Tarea1 IS
    -- Declaración de componentes
    COMPONENT contadec
        PORT(CLK : IN STD_LOGIC;
             D, U : BUFFER INTEGER RANGE 0 TO 9);
    END COMPONENT;

    COMPONENT divf
        PORT(CLK_IN : IN STD_LOGIC;
             CLK_OUT : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT dec_7seg
        PORT(DIGIT : IN INTEGER RANGE 0 TO 9;
             SEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;

    -- Señales internas
    SIGNAL clk_1Hz : STD_LOGIC;
    SIGNAL d, u : INTEGER RANGE 0 TO 9;

BEGIN
    -- Instancias de componentes
    DIV: divf PORT MAP(CLK, clk_1Hz);
    COUNTER: contadec PORT MAP(clk_1Hz, d, u);
    DEC_D: dec_7seg PORT MAP(d, SEG_D);
    DEC_U: dec_7seg PORT MAP(u, SEG_U);
    
END STRUCTURAL;
