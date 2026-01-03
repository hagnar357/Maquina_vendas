library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_4x1 is
    generic (
        N : integer := 4   -- largura do barramento
    );
	 
    Port ( 
		A, B, C, D : in STD_LOGIC_VECTOR(N-1 downto 0);
		Sel : in STD_LOGIC_VECTOR (1 downto 0);
		Sel_out : out STD_LOGIC_VECTOR (N-1 downto 0)	
    );
end Mux_4x1;


architecture Mux of Mux_4x1 is
begin
	with Sel select 
    Sel_out <= 
		A when "00",
		B when "01",
		C when "10",
		D when "11";
end Mux;