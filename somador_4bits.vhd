library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity somador_4bits is
    Port ( 
        Operando_A      : in  STD_LOGIC_VECTOR (3 downto 0);
        Operando_B      : in  STD_LOGIC_VECTOR (3 downto 0);
        Seletor_Op      : in  STD_LOGIC; -- 0|soma e 1|subtração
        Resultado       : out STD_LOGIC_VECTOR (3 downto 0);
        Carry_Out_Final : out STD_LOGIC
    );
end somador_4bits;

architecture Estrutura of somador_4bits is
   
    component somador_completo
        Port ( 
			A, B, Carry_In : in STD_LOGIC;
			Saida_Soma, Carry_Out : out STD_LOGIC
			);
    end component;

    component Complemento2
        Port ( Dado_B_Original : in STD_LOGIC_VECTOR (3 downto 0);
               Modo_Subtracao  : in STD_LOGIC;
               Dado_B_Ajustado : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
	 
    signal Cadeia_Carry : STD_LOGIC_VECTOR (4 downto 0); 
    signal Fio_B_Processado : STD_LOGIC_VECTOR (3 downto 0); -- b mudado ou não dependendo do modo escolhido 

begin

    -- tratamos o b pra a conta
    Instancia_Inversor: Complemento2 port map (
        Dado_B_Original => Operando_B,
        Modo_Subtracao  => Seletor_Op, 
        Dado_B_Ajustado => Fio_B_Processado
    );

   
    Cadeia_Carry(0) <= Seletor_Op; -- +1 comp2

    
    Gerador_Somadores: for i in 0 to 3 generate
        Instancia_Somador_Bit: Somador_completo port map (
            A  => Operando_A(i),
            B  => Fio_B_Processado(i),
            Carry_In   => Cadeia_Carry(i),     
            Saida_Soma => Resultado(i),
            Carry_Out  => Cadeia_Carry(i+1)    
        );
    end generate;

    Carry_Out_Final <= Cadeia_Carry(4);

end Estrutura;