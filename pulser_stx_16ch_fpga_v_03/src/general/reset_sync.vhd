-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author            : Gergely Ivanyi <gergely.ivanyi@norbit.com>
-- Modified/changed : Seyed Husseini   
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description:  Reset syncronizer module
-- PLL module to generate 120e6 Hz refclock from 50e6Hz clock
-- Reset synchronizer which has 16bit shift register
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;

entity reset_sync is
	generic (
		g_active_high_input	: boolean := true;		-- Active high input
		g_active_high_output	: boolean := true		-- Active high output
	);
	port (
		reset			: in  std_logic;		-- Asynchronous reset
		clk			: in  std_logic;		-- Clock
		reset_sync_gen		: out std_logic			-- Synchronous reset
	);
end entity reset_sync;


architecture rtl of reset_sync is

        function boolean2stdlogic(b: in boolean) return std_logic is
		variable s: std_logic;
	begin
		if b then
			s := '1';
		else
			s := '0';
		end if;
		return s;
	end function boolean2stdlogic;

	-- Signals
	signal rst_d  : std_logic;
	signal rst_dd : std_logic;
	signal rst_d1 : std_logic;
	signal rst_d2 : std_logic;

begin

	--reset_sync_gen <= rst_d2;
	reset_sync_gen <= rst_dd;

	-- Process: p_sync_active_high_input
	-- Synchronize active high reset
	gen_active_high_input : if g_active_high_input = true generate
		p_sync_active_high_input : process (reset, clk) is
		begin
			if (reset = '1') then
				rst_d	<= boolean2stdlogic(g_active_high_output);
				rst_dd	<= boolean2stdlogic(g_active_high_output);
				rst_d1	<= boolean2stdlogic(g_active_high_output);
				rst_d2	<= boolean2stdlogic(g_active_high_output);

			elsif rising_edge(clk) then

				rst_d	<= not boolean2stdlogic(g_active_high_output);
				rst_dd	<= rst_d;
				rst_d1	<= rst_dd;
				rst_d2	<= rst_d1;
			end if;
		end process p_sync_active_high_input;
	end generate gen_active_high_input;

	-- Process: p_sync_active_low_input
	-- Synchronize active low reset
	gen_active_low_input : if g_active_high_input = false generate
		p_sync_active_low_input : process (reset, clk) is
		begin
			if (reset = '0') then
				rst_d	<= boolean2stdlogic(g_active_high_output);
				rst_dd	<= boolean2stdlogic(g_active_high_output);
				rst_d1	<= boolean2stdlogic(g_active_high_output);
				rst_d2	<= boolean2stdlogic(g_active_high_output);

			elsif rising_edge(clk) then

				rst_d	<= not boolean2stdlogic(g_active_high_output);
				rst_dd	<= rst_d;
				rst_d1	<= rst_dd;
				rst_d2	<= rst_d1;
			end if;
		end process p_sync_active_low_input;
	end generate gen_active_low_input;

end architecture rtl;
