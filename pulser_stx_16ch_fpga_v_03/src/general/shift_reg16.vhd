

library ieee;
	use ieee.std_logic_1164.all;


entity shift_reg16 is
	generic (
		INITVAL	: std_logic_vector(15 downto 0) := x"ffff"	-- Init value reset value for shift reg
	);
	port(
		clk	: in  std_logic;		-- Main system clk
		i	: in  std_logic;		-- Shift in
		o	: out std_logic			-- Shift out
	);
end entity shift_reg16 ;


architecture rtl of shift_reg16 is

	-- Signals
	signal d	: std_logic_vector(15 downto 0) := INITVAL;

begin
        ---------------------------------------------------------------------------------
	--------------------------- LShift bit 0 first ----------------------------------
        ---------------------------------------------------------------------------------
	shift1: process(clk) is
	begin
		if rising_edge(clk) then
			d(0) <= i;
		end if;
	end process shift1;

	---------------------------------------------------------------------------------
        --------------------------- LShift bit [1 => 15]  -------------------------------
        ---------------------------------------------------------------------------------
	g_shifter : for itr in 1 to 15 generate
	begin
		shift2: process(clk) is
		begin
			if rising_edge(clk) then
				d(itr) <= d(itr-1);
			end if;
		end process shift2;
	end generate g_shifter;

	o <= d(15);

end architecture rtl;
