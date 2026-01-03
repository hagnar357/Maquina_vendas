library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BC is
	generic (
		N : integer := 4 
	);
	port (
		clock   : in  std_logic;
		reset   : in  std_logic;

		M			: in  std_logic;
		B1		: in  std_logic;
		B2		: in  std_logic;

		Acumulador : in  std_logic_vector(N-1 downto 0);
		over_flag  : in  std_logic;

		Sel     : out std_logic_vector(1 downto 0);
		reset_bo: out std_logic;

		f1      : out std_logic;
		f2      : out std_logic;
		nt      : out std_logic;
		vt      : out std_logic_vector(N-1 downto 0)
		);
	end entity;
 
architecture controle of BC is
	type state_t is(
		IDLE,
		ADD,
		BUY,
		DISPENSER,
		TROCO,
		CLEAR
	);
	
	signal state, next_state : state_t;
	signal product : std_logic; -- '0' => produto 1, '1' => produto 2
	
begin
	process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				state <= IDLE;
			else
				state <= next_state;
			end if;
		end if;
	end process;
	
	process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				product <= '0';
			else
				if B1 = '1' then
					product <= '0';
				elsif B2 = '1' then
					product <= '1';
				end if;
			end if;
		end if;
	end process;
	
	process(state, reset, M, B1, B2, Acumulador, over_flag, product)
	begin 
		--default
		Sel      <= "00";
		f1       <= '0';
		f2       <= '0';
		nt       <= '0';
		vt       <= (others => '0');
		reset_bo <= '0';
		
		next_state <= state;
		
		if reset = '1' then
			reset_bo <= '1';
			next_state <= IDLE;
		else
			case state is
				when IDLE =>
					if M = '1' then
						next_state <= ADD;
					elsif (B1 = '1') or (B2 = '1') then
						next_state <= BUY;
					else
						next_state <= IDLE;
					end if;
					
				when ADD =>
					Sel <= "01";
					next_state <= IDLE;
					
				when BUY =>
					if product = '0' then
						Sel <= "10";
					else
						Sel <= "11";
					end if;
					next_state <= DISPENSER;
					
				when DISPENSER =>
					if over_flag='1' then
						next_state <= IDLE;
					else 
						if product = '0' then
							f1 <= '1';
						else 
							f2 <= '1';
						end if;
						
						if Acumulador /= (others=>'0') then
							next_state <= TROCO;
						else
							 next_state <= CLEAR;
						end if;
					end if;
				
				when TROCO =>
					nt <= '1';
					vt <= Acumulador;
					next_state <= CLEAR;
				
				when CLEAR =>
					reset_bo <= '1';
					next_state <= IDLE;
					
				when others =>
					next_state <= IDLE;
			end case;
		end if;
	end process;
end architecture;
			
	
 
	 