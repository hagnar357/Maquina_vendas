library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BO is
	 generic (
        N : integer := 4
    );
    Port ( 
       Sel   : in  STD_LOGIC_VECTOR(1 downto 0);
		 V : in STD_LOGIC_VECTOR (N-1 downto 0);
		 R1, R2 : in STD_LOGIC_VECTOR (N-1 downto 0); -- na pratica vamo usar 3 bits pra ter espaço nas chaves do fpga
       reset : in STD_LOGIC;
		 clock : in STD_LOGIC;
		 Acumulador : out STD_LOGIC_VECTOR(N-1 downto 0);
		 over_flag : out STD_LOGIC
    );
end BO;


architecture opera of BO is

    signal mux_out : STD_LOGIC_VECTOR(N-1 downto 0);
	 signal reg_out : STD_LOGIC_VECTOR(N-1 downto 0);
	 signal soma_out : STD_LOGIC_VECTOR(N-1 downto 0);
	 signal flag: STD_LOGIC;
	 
begin

	 U_MUX : entity work.Mux_4x1
        generic map (
            N => N
        )
        port map (
            A => (others => '0'),
            B => V,
            C => R1,
            D => R2,
            Sel => Sel,
            Sel_out => mux_out
        );
	
	 U_SOMA : entity work.somador_4bits
		port map(
				Operando_A => reg_out,
				Operando_B => mux_out,
				Seletor_Op => Sel(1), --- subtração é feita sempre com R1 e R2
				Resultado  => soma_out,
				Carry_Out_Final => flag
		);
		
	u_REG : entity work.registrador
		generic map(
			N => N
		)
		port map(
			clk => clock ,
			rst => reset,
			en  => not flag,
			D  => soma_out,
			Q  => reg_out
			);
			
	Acumulador <= reg_out;
	over_flag <= flag;
end opera;