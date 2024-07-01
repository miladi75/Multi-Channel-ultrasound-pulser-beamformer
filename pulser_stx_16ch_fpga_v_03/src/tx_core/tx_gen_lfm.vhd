-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi 
-- Edit/Modified: Seyed
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description: Generate sawtooth chirp pulse with starting fc, slope_rate 
-- (rate increase/decrease)
-- start_slope = ((fc-bw/2) / fs * 2**G_DATA_WIDTH)
-- slope increment slope_rate = (2**G_DATA_WIDTH * bw / (pulse_length * fs))  
-- Chirp chirp_mode. 0: increasing freq, 1: decreasing freq
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------




library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity tx_gen_lfm is
	generic(
		G_DATA_WIDTH	: integer := 16
	);
	port(
		clk		:  in std_logic;					
		rst_n		:  in std_logic;					
                chirp_mode      :  in std_logic;		                -- Mode bit 0/1: incr/decr freq
		start		:  in std_logic;					-- Start signal
		smp_tick	:  in std_logic;					-- sample tick
                pulse_length	:  in std_logic_vector(22 downto 0);			-- number of samples
		start_slope	:  in std_logic_vector(11 downto 0);			-- starting slope (f0 / fs * 2**G_DATA_WIDTH)
		slope_rate	:  in std_logic_vector(19 downto 0);			-- slope increment (2**G_DATA_WIDTH * bw / (pulse_length * fs))
		-- freq		:  in std_logic_vector(G_DATA_WIDTH - 1 downto 0);	--
		-- bw		:  in std_logic_vector(G_DATA_WIDTH - 1 downto 0);	--
		pulse_valid		: out std_logic;					-- pulse_data pulse_valid
		pulse_data		: out std_logic_vector(G_DATA_WIDTH downto 0)	--
		
	);
end entity tx_gen_lfm;


architecture rtl of tx_gen_lfm is

	-- Signal declaration(s)
	-- signal saw_valid	: std_logic;
	-- signal saw_data		: std_logic_vector(G_DATA_WIDTH downto 0);

        constant C_FRAC_BITS		: natural range 0 to 32 := 19;
        constant C_ZEROS_N		: std_logic_vector(C_FRAC_BITS + 1 downto 0) := (others => '0');
        constant C_SAW_SUB		: signed(G_DATA_WIDTH + 2 downto 0) := to_signed(2**(G_DATA_WIDTH+1), G_DATA_WIDTH + 3);
        -- Signals 
	signal valid_i			: std_logic;
	-- signal smp_tick_d		: std_logic_vector(3 downto 0);
	signal smp_cnt			: unsigned(pulse_length'range);
	signal cnt			: unsigned(G_DATA_WIDTH + 1 + C_FRAC_BITS downto 0);
	signal cnt_sgn_19		: signed(G_DATA_WIDTH + 2 downto 0);
	signal length_i			: unsigned(pulse_length'range);
	signal start_slope_scl		: std_logic_vector(G_DATA_WIDTH + 1 + C_FRAC_BITS downto 0);
	
	signal slope			: unsigned(G_DATA_WIDTH + 1 + C_FRAC_BITS downto 0);
        signal slope_rate_i			: unsigned(slope_rate'range);
	signal sawtooth_i		: signed(G_DATA_WIDTH + 2 downto 0);
	
	signal enable_i			: std_logic;
        

begin



        start_slope_scl	<= "0000" & start_slope & C_ZEROS_N;
        cnt_sgn_19      <= signed(resize(cnt(cnt'high downto C_FRAC_BITS), G_DATA_WIDTH + 3));
        
        pulse_valid		<= valid_i;
        pulse_data		<= std_logic_vector(sawtooth_i(G_DATA_WIDTH + 1 downto 1));

	-- process : proc_SAW_LFM
	-- Generates 18 bit sawtooth chirp based
	-- on 2 parameters: starting slope, and
	-- slope_rate (slope increment value)
	proc_SAW_LFM : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			smp_cnt		<= (others => '0');
			cnt		<= (others => '0');
			sawtooth_i	<= (others => '0');
			-- smp_tick_d	<= (others => '0');
			valid_i		<= '0';
			-- sign_change	<= '0';
                        -- sawtooth_i_2	<= (others => '0');

		elsif rising_edge(clk) then
			-- smp_tick_d	<= smp_tick_d(smp_tick_d'high - 1 downto 0) & smp_tick;
			valid_i		<= enable_i and smp_tick;

			if start = '1' then
				enable_i	<= '1';
				smp_cnt		<= (others => '0');
				cnt		<= (others => '0');
				
				length_i	<= unsigned(pulse_length) - 1;
				slope		<= unsigned(start_slope_scl);
				slope_rate_i	<= unsigned(slope_rate);
			end if;

			
			if enable_i = '1' and smp_tick = '1' then

				if smp_cnt <= length_i then
					smp_cnt	<= smp_cnt + 1;
					cnt	<= cnt + slope;

					-- if chirp_mode = '0' then
                                        if chirp_mode = '0' then
						slope	<= slope + slope_rate_i;
					else
						slope	<= slope - slope_rate_i;
					end if;
				end if;
			end if;

			if smp_cnt >= unsigned(pulse_length) then
				enable_i	<= '0';
				valid_i		<= '0';
				smp_cnt		<= (others => '0');
				cnt		<= (others => '0');
			end if;

			sawtooth_i	<= cnt_sgn_19 - C_SAW_SUB;

		end if;
	end process proc_SAW_LFM;




end architecture rtl;
