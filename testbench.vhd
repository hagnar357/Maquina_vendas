library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_TOP is
end entity;

architecture sim of TB_TOP is
  constant N : integer := 4;

  signal clock : std_logic := '0';
  signal reset : std_logic := '0';

  signal M  : std_logic := '0';
  signal V  : std_logic_vector(N-1 downto 0) := (others => '0');
  signal R1 : std_logic_vector(N-1 downto 0) := (others => '0');
  signal R2 : std_logic_vector(N-1 downto 0) := (others => '0');
  signal B1 : std_logic := '0';
  signal B2 : std_logic := '0';

  signal f1, f2, nt : std_logic;
  signal vt : std_logic_vector(N-1 downto 0);

begin
  DUT: entity work.TOP
    generic map (N => N)
    port map (
      clock => clock,
      reset => reset,
      M => M,
      V => V,
      R1 => R1,
      R2 => R2,
      B1 => B1,
      B2 => B2,
      f1 => f1,
      f2 => f2,
      nt => nt,
      vt => vt
    );

  -- clock 10ns
  clock <= not clock after 5 ns;

  process
  begin
    -- preços
    R1 <= "0101"; -- 5
    R2 <= "0111"; -- 7

    -- reset
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait for 20 ns;

    -- Insere 2
    V <= "0010"; M <= '1'; wait for 10 ns; M <= '0'; wait for 30 ns;

    -- Insere 3 (saldo 5)
    V <= "0011"; M <= '1'; wait for 10 ns; M <= '0'; wait for 30 ns;

    -- Compra produto 1 (R1=5)
    B1 <= '1'; wait for 10 ns; B1 <= '0';
    wait for 200 ns;

    -- Insere 4
    V <= "0100"; M <= '1'; wait for 10 ns; M <= '0'; wait for 30 ns;

    -- Insere 3 (saldo 7)
    V <= "0011"; M <= '1'; wait for 10 ns; M <= '0'; wait for 30 ns;

    -- Compra produto 2 (R2=7)
    B2 <= '1'; wait for 10 ns; B2 <= '0';
    wait for 200 ns;

    wait;
  end process;

end architecture;
