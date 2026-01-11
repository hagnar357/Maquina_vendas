library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_TOP is
end tb_TOP;

architecture sim of tb_TOP is

    constant N : integer := 4;
    constant CLK_PERIOD : time := 20 ns;

    -- sinais de entrada
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal M  : std_logic := '0';
    signal B1 : std_logic := '0';
    signal B2 : std_logic := '0';

    signal V  : std_logic_vector(N-1 downto 0) := "0010"; -- moeda = 2
    signal R1 : std_logic_vector(N-1 downto 0) := "0001"; -- produto 1 = 1
    signal R2 : std_logic_vector(N-1 downto 0) := "0011"; -- produto 2 = 3

    -- saídas
    signal f1 : std_logic;
    signal f2 : std_logic;
    signal nt : std_logic;
    signal vt : std_logic_vector(N-1 downto 0);

begin

    -- =========================
    -- CLOCK
    -- =========================
    clock <= not clock after CLK_PERIOD/2;

    -- =========================
    -- DUT (TOP)
    -- =========================
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

    -- =========================
    -- ESTÍMULOS
    -- =========================
    stim : process
    begin
        ------------------------------------------------
        -- RESET GLOBAL
        ------------------------------------------------
        reset <= '1';
        wait for 2*CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        ------------------------------------------------
        -- INSERIR MOEDA (2)
        ------------------------------------------------
        M <= '1';
        wait for CLK_PERIOD;
        M <= '0';
        wait for 3*CLK_PERIOD;

        ------------------------------------------------
        -- COMPRAR PRODUTO 1 (custa 1)
        ------------------------------------------------
        B1 <= '1';
        wait for CLK_PERIOD;
        B1 <= '0';
        wait for 5*CLK_PERIOD;

        ------------------------------------------------
        -- INSERIR MOEDA (2)
        ------------------------------------------------
        M <= '1';
        wait for CLK_PERIOD;
        M <= '0';
        wait for 3*CLK_PERIOD;

        ------------------------------------------------
        -- COMPRAR PRODUTO 2 (custa 3)
        ------------------------------------------------
        B2 <= '1';
        wait for CLK_PERIOD;
        B2 <= '0';
        wait for 5*CLK_PERIOD;

        ------------------------------------------------
        -- TENTAR COMPRAR SEM SALDO (erro)
        ------------------------------------------------
        B1 <= '1';
        wait for CLK_PERIOD;
        B1 <= '0';
        wait for 5*CLK_PERIOD;

        ------------------------------------------------
        -- FIM DA SIMULAÇÃO
        ------------------------------------------------
        wait;
    end process;

end sim;
