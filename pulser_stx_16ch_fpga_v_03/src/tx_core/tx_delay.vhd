

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;




entity tx_delay is
	generic(
		G_CH			: natural range 0 to 15
	);
	port(
		clk			:  in std_logic;			
		rst_n			:  in std_logic;			
		en			:  in std_logic;			
		-- mode			:  in std_logic;			
		start			:  in std_logic;			
		cnt_delay		:  in std_logic_vector(19 downto 0);	
		custom_delay_valid	:  in std_logic;			
		custom_delay		:  in std_logic_vector(19 downto 0);	
		smp_tick		: out std_logic;			
		win_tick		: out std_logic;			
		start_wind		: out std_logic;			
		start_pulse		: out std_logic				
	);
end entity tx_delay;


architecture rtl of tx_delay is

	-- Constant declarations
	
        -- constant C_CENTER_DELAY_64CH	: signed(16 downto 0) := to_signed(2**13, 17);
        -- constant C_CENTER_DELAY_128CH	: signed(16 downto 0) := to_signed(2**14, 17);
        -- calc_delay_uns	<= unsigned(std_logic_vector(calc_delay(16 downto 0)));
        
        constant C_LATENCY_WIND		: natural := 6;
	constant C_LATENCY_PULSE	: natural := C_LATENCY_WIND + 24;
	
	


	constant SAMPLE_RATE_MAX	: unsigned(2 downto 0) := to_unsigned(1, 3);
	constant WIN_SMP_RATE_MAX	: unsigned(3 downto 0) := to_unsigned(15, 4);
	-- Signal declarations
	


        signal start_sent		: std_logic;
	
	-- signal calc_delay_uns		: unsigned(16 downto 0);
	signal smp_tick_i		: std_logic;
	signal win_tick_i		: std_logic;

	signal smp_cnt			: unsigned(2 downto 0);
	signal win_cnt			: unsigned(3 downto 0);
	-- signal pls_cnt			: unsigned(5 downto 0);
        signal start_shr		: std_logic_vector(C_LATENCY_PULSE-C_LATENCY_WIND-1 downto 0);
        signal delayed_start_i		: std_logic;
        -- signal calc_delay		: signed(17 downto 0);

begin

	
	smp_tick	<= smp_tick_i;
	win_tick	<= win_tick_i;

	start_wind	<= delayed_start_i;
	start_pulse	<= start_shr(start_shr'high);

	-- Process : proc_DELAYED_START
	-- Delays start signal by custom, or
	-- calculated number of 120 MHz samples
	-- delay_value * 8.333 ns
	proc_DELAYED_START : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			delayed_start_i	<= '0';
			start_sent	<= '0';

		elsif rising_edge(clk) then
			delayed_start_i	<= '0';
			start_shr	<= start_shr(start_shr'high - 1 downto 0) & delayed_start_i;

			if start = '1' then
				start_sent	<= '0';
			end if;

			if en = '1' then
				if start_sent = '0' then
                                        if custom_delay_valid = '1' then
						if unsigned(cnt_delay) > unsigned(custom_delay) then
							delayed_start_i	<= '1';
							start_sent	<= '1';
							
						end if;
					end if;
				end if;
			end if;
		end if;
	end process proc_DELAYED_START;

	-- Process : proc_SMP_TICK
	-- Generating sample tick of N times higher frequency
	-- than specified sample rate
	-- The PWM is 2-31 level (1 - 8 bit), so it needs to switch
	-- (SAMPLE_RATE_MAX(i) + 1) times faster than the 40 MHz tick
	proc_SMP_TICK : process (clk, rst_n) is
	
	begin
		if rst_n = '0' then
			smp_tick_i	<= '0';
			win_tick_i	<= '0';
			smp_cnt		<= (others => '0');
			win_cnt		<= (others => '0');

		elsif rising_edge(clk) then
			smp_tick_i	<= '0';
			win_tick_i	<= '0';

			if delayed_start_i = '1' then
				-- Trigger start restart counters, so time-difference between
				-- trigger and first TX sequence is always the same
				smp_cnt	<= (others => '0');
				win_cnt	<= (others => '0');
			else
				if smp_cnt >= SAMPLE_RATE_MAX then
					smp_cnt		<= (others => '0');
					smp_tick_i	<= '1';
				else
					smp_cnt		<= smp_cnt + 1;
				end if;

				if win_cnt >= WIN_SMP_RATE_MAX then
					win_cnt		<= (others => '0');
					win_tick_i	<= '1';
				else
					win_cnt		<= win_cnt + 1;
				end if;
			end if;
		end if;
	end process proc_SMP_TICK;

end architecture rtl;
