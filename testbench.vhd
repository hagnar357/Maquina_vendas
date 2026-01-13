library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity tb_TOP is
end tb_TOP;

architecture sim of tb_TOP is

    constant N : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    -- Entradas
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal M  : std_logic := '0';
    signal B1 : std_logic := '0';
    signal B2 : std_logic := '0';

    signal V  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal R1 : std_logic_vector(N-1 downto 0) := (others => '0');
    signal R2 : std_logic_vector(N-1 downto 0) := (others => '0');

    -- Saídas
    signal f1 : std_logic;
    signal f2 : std_logic;
    signal nt : std_logic;
    signal vt : std_logic_vector(N-1 downto 0);

    -- Arquivo
    file stim_file : text open read_mode is "test.txt";

begin

    --------------------------------------------------
    -- CLOCK
    --------------------------------------------------
    clock <= not clock after CLK_PERIOD/2;

    --------------------------------------------------
    -- DUT
    --------------------------------------------------
    DUT : entity work.TOP
        generic map ( N => N )
        port map (
            clock => clock,
            reset => reset,
            M  => M,
            V  => V,
            R1 => R1,
            R2 => R2,
            B1 => B1,
            B2 => B2,
            f1 => f1,
            f2 => f2,
            nt => nt,
            vt => vt
        );

    --------------------------------------------------
    -- LEITURA SINCRONIZADA AO CLOCK
    --------------------------------------------------
    stim_proc : process
        variable L : line;

        variable v_reset : std_logic;
        variable v_M     : std_logic;
        variable v_B1    : std_logic;
        variable v_B2    : std_logic;

        variable v_V  : std_logic_vector(N-1 downto 0);
        variable v_R1 : std_logic_vector(N-1 downto 0);
        variable v_R2 : std_logic_vector(N-1 downto 0);
    begin
        -- espera o primeiro clock
        wait until rising_edge(clock);

        while not endfile(stim_file) loop
            readline(stim_file, L);

            read(L, v_reset);
            read(L, v_M);
            read(L, v_B1);
            read(L, v_B2);
            read(L, v_V);
            read(L, v_R1);
            read(L, v_R2);

            -- aplica sinais SINCRONIZADOS
            reset <= v_reset;
            M     <= v_M;
            B1    <= v_B1;
            B2    <= v_B2;
            V     <= v_V;
            R1    <= v_R1;
            R2    <= v_R2;

            wait until rising_edge(clock);
				reset <= '0';
            M     <= '0';
            B1    <= '0';
            B2    <= '0';
				wait until rising_edge(clock);
        end loop;

        -- final da simulação
        wait;
    end process;

end sim;
