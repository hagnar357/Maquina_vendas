library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registrador_N is
    generic (
        N : integer := 4   -- largura do registrador
    );
    port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;  -- reset síncrono
        en    : in  STD_LOGIC;  -- enable
        D     : in  STD_LOGIC_VECTOR(N-1 downto 0); -- entrada paralela
        Q     : out STD_LOGIC_VECTOR(N-1 downto 0)  -- saída paralela
    );
end Registrador_N;

architecture RTL of Registrador_N is
    signal reg : STD_LOGIC_VECTOR(N-1 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg <= (others => '0');
            elsif en = '1' then
                reg <= D;
            end if;
        end if;
    end process;

    Q <= reg;

end RTL;
