library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Complemento2 is
    generic (
        N : integer := 4   -- largura do barramento
    );
    Port ( 
        Dado_B_Original  : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Modo_Subtracao   : in  STD_LOGIC; -- 0 = Soma (Mantém), 1 = Subtração (Inverte)
        Dado_B_Ajustado  : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end Complemento2;

architecture Comportamento of Complemento2 is
begin
    process(Dado_B_Original, Modo_Subtracao)
    begin        
        for i in 0 to N-1 loop
            Dado_B_Ajustado(i) <= Dado_B_Original(i) XOR Modo_Subtracao;
        end loop;
    end process;
end Comportamento;