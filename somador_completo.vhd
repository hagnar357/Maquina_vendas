library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Somador_completo is
    Port ( 
       A, B, Carry_In   : in  STD_LOGIC;
       Saida_Soma, Carry_Out   : out STD_LOGIC
    );
end Somador_completo;


architecture soma of Somador_completo is
begin
    Saida_Soma <= A XOR B XOR Carry_In;
    Carry_Out  <= (A AND B) OR (Carry_In AND (A XOR B));
end soma;

