library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is 
	generic(
		N : integer := 8
	);
	
	port(
		clock   : in  std_logic;
		reset   : in  std_logic;
		
		M       : in  std_logic;
		V		  : in  std_logic_vector(N-1 downto 0);
		R1		  : in  std_logic_vector(N-1 downto 0);
		R2		  : in  std_logic_vector(N-1 downto 0);
		B1		  : in  std_logic;
		B2		  : in  std_logic;
		
		f1 	  : out std_logic;
		f2 	  : out std_logic;
		nt 	  : out std_logic;
		vt 	  : out std_logic_vector(N-1 downto 0)
	);
end TOP;

architecture rtl of TOP is

  signal Sel_s       : std_logic_vector(1 downto 0);
  signal reset_bc_bo : std_logic;

  signal acumulador_s : std_logic_vector(N-1 downto 0);
  signal over_flag_s  : std_logic;

  signal reset_bo_total : std_logic;

begin

  reset_bo_total <= reset or reset_bc_bo;

  -- ====== BC ======
  U_BC: entity work.BC
    generic map (N => N)
    port map (
      clock => clock,
      reset => reset,

      M  => M,
      B1 => B1,
      B2 => B2,

      Acumulador => acumulador_s,
      over_flag  => over_flag_s,

      Sel      => Sel_s,
      reset_bo => reset_bc_bo,

      f1 => f1,
      f2 => f2,
      nt => nt,
      vt => vt
    );

  -- ====== BO ======
  U_BO: entity work.BO
    generic map (N => N)
    port map (
      Sel      => Sel_s,
      V        => V,
      R1       => R1,
      R2       => R2,
      reset_bo => reset_bo_total, 
      clock    => clock,

      Acumulador => acumulador_s,
      over_flag  => over_flag_s
    );

end architecture;