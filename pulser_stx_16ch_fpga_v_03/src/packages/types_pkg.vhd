-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi 
-- Edit/Modified: Seyed (chaned alot and moved some stuff from std_logic_1164_addition)
-- package (on Github)
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Type definitions for the theis project. This module has been modified and 
-- changed form the original file to suit this project
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;



package types_pkg is
        subtype slv3_t is std_logic_vector(2 downto 0);
        subtype slv8_t is std_logic_vector(7 downto 0);
        subtype slv20_t is std_logic_vector(19 downto 0);
        subtype slv32_t is std_logic_vector(31 downto 0);
        
        type slv3_vector_t is array (natural range <>) of slv3_t;
        type slv8_vector_t is array (natural range <>) of slv8_t;
        type slv32_vector_t is array (natural range <>) of slv32_t;
        type slv20_vector_t is array (natural range <>) of slv20_t;


	type tx_ctrl_t is record
		apz			: std_logic_vector(8 downto 0);
		delay_mode		: std_logic;
		pulse_gen_mode		: std_logic_vector(2 downto 0);
		window_mode		: std_logic;
		pwm_mode		: std_logic_vector(1 downto 0);
		custom_delay		: std_logic_vector(19 downto 0);
		tri_start_slope		: std_logic_vector(11 downto 0);
		tri_dslope		: std_logic_vector(19 downto 0);
		--sin_freq		: std_logic_vector(15 downto 0);
		--sin_bw			: std_logic_vector(15 downto 0);
		window_slope		: std_logic_vector(31 downto 0);
	end record tx_ctrl_t;

	type param_valid_t is record
		ctrl		: std_logic; -- apz, modes (pulse, dly, window)
		custom_delay	: std_logic; -- delay from RAM
		tri		: std_logic; -- start_slope, dslope
		sine		: std_logic; -- freq, bw
		window		: std_logic; -- sample, incr
		pwm_thres	: std_logic; -- pwm threshold levels
	end record param_valid_t;

	constant param_valid_IDLE	: param_valid_t := (	ctrl		=> '0',
								custom_delay	=> '0',
								tri		=> '0',
								sine		=> '0',
								window		=> '0',
								pwm_thres	=> '0');

	constant tx_ctrl_IDLE		: tx_ctrl_t := (apz			=> (others => '0'),
							delay_mode		=> '0',
							pulse_gen_mode		=> (others => '0'),
							window_mode		=> '0',
							pwm_mode		=> (others => '0'),
							custom_delay		=> (others => '0'),
							tri_start_slope		=> (others => '0'),
							tri_dslope		=> (others => '0'),
							--sin_freq		=> (others => '0'),
							--sin_bw			=> (others => '0'),
							window_slope		=> (others => '0')
							);

end package types_pkg;

package body types_pkg is


end package body types_pkg;
