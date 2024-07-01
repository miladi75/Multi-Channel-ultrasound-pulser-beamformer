
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi 
-- Edit/Modified: Seyed (chaned alot and made this rtl level to do all the 
-- calcualtions in this module and moved.
-- package (on Github)
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description: Multiply PWM_width and windows to get the windowing effect
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;



entity tx_mult is
	generic(
		G_DATA_WIDTH		: natural := 18
	);
	port(
		clk			:  in std_logic;					-- Clock
		rst_n			:  in std_logic;					-- Reset
		pwm_width		:  in std_logic_vector(12 downto 0);
		-- apz_valid		:  in std_logic;-- := '1';
		apz			:  in std_logic_vector(8 downto 0);
		wind_valid		:  in std_logic;
		wind_data			:  in std_logic_vector(8 downto 0);
		pwm_w_valid		: out std_logic;
		pwm_width_scl		: out std_logic_vector(12 downto 0)
	);
end entity tx_mult;


architecture rtl of tx_mult is

	-- Constant declarations
	constant C_MULT_DELAY	: natural range 0 to 3 := 3;
	-- Signal declarations
	signal data_a		: signed(G_DATA_WIDTH - 1 downto 0);
	signal data_b		: signed(G_DATA_WIDTH - 1 downto 0);
	signal mult_res		: signed(2*G_DATA_WIDTH - 1 downto 0);
	signal mult_valid_dc	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
        signal data_a_1		: signed(G_DATA_WIDTH - 1 downto 0);
	signal data_b_1		: signed(G_DATA_WIDTH - 1 downto 0);
	signal mult_res_1	: signed(2*G_DATA_WIDTH - 1 downto 0);
	signal dch_pow2		: signed(G_DATA_WIDTH - 1 downto 0);
	signal wind_x_apz	: signed(G_DATA_WIDTH - 1 downto 0);
	signal mult_valid_str	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
	signal mult_valid_foc	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
	signal mult_valid_foc1	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
	signal mult_valid_win	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
	signal mult_valid_smp	: std_logic_vector(C_MULT_DELAY - 1 downto 0);
	
	signal mult_pulse	: std_logic;
	signal mult_focus_1	: std_logic;
	signal valid_win_apz	: std_logic;

        attribute multstyle	: string;
        attribute multstyle of rtl : architecture is "dsp";
        
        signal a_reg		: signed (G_DATA_WIDTH - 1 downto 0);
        signal b_reg		: signed (G_DATA_WIDTH - 1 downto 0);
        
        
        
        signal result_reg	: signed (2*G_DATA_WIDTH -1 downto 0);




begin
	-- Ouput assignments
	valid_win_apz	<= mult_valid_win(C_MULT_DELAY - 1);
	pwm_w_valid	<= mult_valid_dc(C_MULT_DELAY - 1);
	pwm_width_scl	<= std_logic_vector(mult_res(28 downto 16));





	p_mode_mux : process(clk, rst_n) is
	begin
		if (rst_n = '0') then
			data_a		<= (others => '0');
			data_b		<= (others => '0');

		elsif rising_edge(clk) then

			mult_valid_win	<= mult_valid_win(C_MULT_DELAY - 2 downto 0) & wind_valid;
			mult_valid_dc	<= mult_valid_dc(C_MULT_DELAY - 2 downto 0) & valid_win_apz;

			if wind_valid = '1' then
				data_a	<= signed(resize(unsigned(wind_data), G_DATA_WIDTH));
				data_b	<= signed(resize(unsigned(apz), G_DATA_WIDTH));

                        elsif valid_win_apz = '1' then
				data_a	<= signed(resize(unsigned(pwm_width), G_DATA_WIDTH));
				data_b	<= signed(resize(unsigned(mult_res), G_DATA_WIDTH));
			end if;
		end if;
	end process p_mode_mux;

        process (clk, rst_n)
	begin
		if (rst_n = '0') then
			a_reg		<= (others => '0');
			b_reg		<= (others => '0');
			result_reg	<= (others => '0');

		elsif rising_edge(clk) then
			a_reg		<= data_a;
			b_reg		<= data_b;

			result_reg	<= a_reg * b_reg;
                        -- mult_res	<= a_reg * b_reg;
                        

			
		end if;
	end process;

	mult_res <= result_reg;



end architecture rtl;


