library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Proyecto1 is
    Port ( clk       : in  STD_LOGIC;  -- Reloj de entrada para multiplexar
           BCD       : buffer STD_LOGIC_VECTOR (3 downto 0);
           segmentos : out STD_LOGIC_VECTOR (6 downto 0);
           anodos    : out STD_LOGIC_VECTOR (8 downto 0) -- Control de dígitos
    );
end entity Proyecto1;

architecture Behavioral of Proyecto1 is
    -- Asegurar que la cantidad de bits sea correcta (42 bits)
		--constant digitos : STD_LOGIC_VECTOR(41 downto 0) := "001100100000000001010110100000000111000000";
    signal digitos : STD_LOGIC_VECTOR(41 downto 0);
	 signal contador : INTEGER range 0 to 8 := 0;
begin
    process(clk)
    begin
		if rising_edge(clk) then
        digitos <= "001100100000000001010110100000000111000000";
        contador <= (contador + 1) mod 9;
		end if;
    end process;

    -- Seleccionar el dígito actual
    BCD <= digitos(contador*4+3 downto contador*4);

    -- Decodificador de 7 segmentos
    process(BCD)
    begin
        case BCD is
            when "0000" => segmentos <= "1000000"; -- 0
            when "0001" => segmentos <= "1111001"; -- 1
            when "0010" => segmentos <= "0100100"; -- 2
            when "0011" => segmentos <= "0110000"; -- 3
            when "0100" => segmentos <= "0011001"; -- 4
            when "0101" => segmentos <= "0010010"; -- 5
            when "0110" => segmentos <= "0000010"; -- 6
            when "0111" => segmentos <= "1111000"; -- 7
            when "1000" => segmentos <= "0000000"; -- 8
            when "1001" => segmentos <= "0010000"; -- 9
            when others => segmentos <= "1111111"; -- Apagar
        end case;
    end process;

    -- Activar solo un anodo a la vez
    process(contador)
    begin
        anodos <= "111111111"; -- Apagar todos los dígitos
        anodos(contador) <= '0'; -- Activar el dígito correspondiente
    end process;
end architecture Behavioral;
