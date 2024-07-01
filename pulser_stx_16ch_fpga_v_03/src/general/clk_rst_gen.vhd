-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Seyed 
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description:  Clock and reset generator
-- PLL module to generate 120e6 Hz refclock from 50e6Hz clock
-- Reset synchronizer which has 16bit shift register
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;


library pll_50;



entity clk_rst_gen is
	port(
		refclk		:  in std_logic;	-- Reference clock, 50 MHz 
		clk		: out std_logic;	-- System clock, 120 MHz out of pll_50.qip
		rst_n		: out std_logic	        -- Reset, release synched to main clock
		
  	);
end entity clk_rst_gen;


architecture str of clk_rst_gen is


	signal pll_reset	: std_logic;
	signal pll_locked	: std_logic;
	signal clk_i		: std_logic;
	signal rst_n_i		: std_logic;


begin

	-- Shift register:
	-- Provides 16 clock period of reset
	-- signal for PLL
	inst_SHIFT16 : entity work.shift_reg16(rtl)
	generic map(
		INITVAL => x"ffff"
	)
	port map(
		clk	=> refclk,
		i	=> '0',
		o	=> pll_reset
	);

	-- PLL_50
	c_pll_50 : entity pll_50.pll_50(rtl)
	port map(
		refclk		=> refclk, 		-- 50 MHz
		rst		=> pll_reset,
		outclk_0	=> clk_i,		-- 120 MHz
		locked		=> pll_locked
	);

	inst_RST_SYNC: entity work.reset_sync(rtl)
	generic map(
		g_active_high_input	=> false,
		g_active_high_output	=> false
	)
	port map(
		reset			=> pll_locked,
		clk				=> clk_i,
		reset_sync_gen	=> rst_n_i
	);

	-- Output assignments
	clk			<= clk_i;
	
	rst_n		<= rst_n_i;
	
	

end architecture str;
