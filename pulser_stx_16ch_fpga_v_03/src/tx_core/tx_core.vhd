
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.types_pkg.all;
-- use work.common.all;


entity tx_core is
	generic(
		G_CH			: natural range 0 to 15
		
	);
	port(
		clk			:  in std_logic;				-- Clock
		rst_n			:  in std_logic;				-- Reset
		
		
		enable			:  in std_logic;--std_logic_vector(15 downto 0);-- := '1';			-- Pulser enable
		-- tx_trigger		:  in std_logic;				-- TX trigger
		start			:  in std_logic;				-- Start signal
		-- start_d			:  in std_logic;				-- Start signal delayed
		-- param_ram_sw_req        :  in std_logic_vector(1 downto 0);		-- Param RAM switch requests
		-- last_pulse		:  in std_logic;				-- Last pulse to be transmitted (for PWR BRD charge EN)
		cnt_delay		:  in std_logic_vector(19 downto 0);		-- Counter for delay, starting at start signal
		
		
		pulse_length	        :  in std_logic_vector(22 downto 0);		-- Number of sample in current pulse (length = LSB * 16.666 sec)
		pwm_width		:  in std_logic_vector(12 downto 0);		-- Maximal width of a PWM pulse (width = LSB * 16.666 sec)
		ctrl_custom_delay       :  in unsigned(19 downto 0);
                ctrl_start_slope        :  in std_logic_vector(11 downto 0);
                ctrl_slope_rate         :  in std_logic_vector(19 downto 0);
                ctrl_trap_slope         :  in std_logic_vector(31 downto 0);
                pwm_p			: out std_logic;				-- PWM signal for pulser circuits +
		pwm_n			: out std_logic;				-- PWM signal for pulser circuits -
		pwm_active		: out std_logic					-- Channel PWM active
	);
end entity tx_core;


architecture str of tx_core is

	-- Constant declarations
	constant C_MULT_DATA_WIDTH	: natural range 1 to 32 := 18;
	-- Signal declarations
	signal enable_ch		: std_logic;--_vector(15 downto 0);
        signal start_d			: std_logic;
        signal start_dd			: std_logic;
        signal start_ddd		: std_logic;
        signal start_dddd		: std_logic;
	
        signal window_valid		: std_logic;
        signal wind_data		: std_logic_vector(8 downto 0);
        signal pulse_valid		: std_logic;
        signal pulse_data		: std_logic_vector(16 downto 0);

	signal smp_tick			: std_logic;
	signal win_tick			: std_logic;
	signal pwm_active_i		: std_logic;
        signal start_wind		: std_logic;

	signal param_valid		: param_valid_t;
	-- signal tx_ctrl			: tx_ctrl_t;

	signal start_dly		: std_logic;
	
	signal delay_mode		: std_logic;
	signal pulse_gen_mode		: std_logic_vector(2 downto 0);
	signal window_mode		: std_logic;
	signal pwm_mode			: std_logic_vector(1 downto 0);

	signal pwm_w_valid		: std_logic;
	signal pwm_width_scaled		: std_logic_vector(12 downto 0);

	signal start_pulse		: std_logic;

	signal window_done		: std_logic;
	signal window_done_d		: std_logic;
	
	

        
        -- Corresponds to a delay(42*8.33ns=350ns) between PWM channels for beamsteering/focusing
        -- constant C_CUSTOM_DELAY_ZERO    : natural := 1; -- No delay 
        
        

begin

	-- apz_en		<= tx_ctrl.apz(0) or tx_ctrl.apz(1) or tx_ctrl.apz(2) or tx_ctrl.apz(3) or
	-- 		   tx_ctrl.apz(4) or tx_ctrl.apz(5) or tx_ctrl.apz(6) or tx_ctrl.apz(7) or tx_ctrl.apz(8);

	enable_ch	<= enable;-- and apz_en;
	-- tx_ctrl.apz     <= '1' & x"00";
        



	c_param_ram : entity work.tx_ram_ctrl(str)

	port map(
		clk		=> clk,
		rst_n		=> rst_n,
		enable		=> enable,
                start		=> start,
                param_valid	=> param_valid
	);

	
	

	c_delay : entity work.tx_delay(rtl)
	generic map(
		G_CH			=> G_CH
	)
	port map(
		clk			=> clk,
		rst_n			=> rst_n,
		en			=> enable_ch,
		start			=> start,
		cnt_delay		=> cnt_delay,
		custom_delay_valid	=> param_valid.custom_delay,
		-- custom_delay		=> tx_ctrl.custom_delay,
                -- custom_delay		=> std_logic_vector(to_unsigned(C_CUSTOM_DELAY_VAL + G_CH * C_CUSTOM_DELAY_VAL, 20)),
                custom_delay            => std_logic_vector(resize(ctrl_custom_delay + G_CH * ctrl_custom_delay, 20)),
		smp_tick		=> smp_tick,
		win_tick		=> win_tick,
		start_wind		=> start_wind,
		start_pulse		=> start_pulse
	);

	c_pulse_gen : entity work.tx_gen_lfm(rtl)
	port map(
		clk		=> clk,
		rst_n		=> rst_n,
		chirp_mode	=> '0', -- mode bit 0/1: up/down chirp
		start		=> start_pulse,
		smp_tick	=> smp_tick,
		pulse_length	=> pulse_length,
		-- start_slope	=> x"418", -- 960kHz -- ctrl_start_slope (1048)
                start_slope	=> ctrl_start_slope, -- 960kHz -- ctrl_start_slope
		-- slope_rate	=> x"00131", -- bw = 80
                slope_rate	=> ctrl_slope_rate, -- bw = 80 (305)

		pulse_valid	=> pulse_valid,
		pulse_data	=> pulse_data
	);

	c_window : entity work.tx_wind(rtl)
	port map(
		clk		=> clk,
		rst_n		=> rst_n,
		-- mode		=> window_mode,
		start_wind	=> start_wind,
		win_tick	=> win_tick,
		wind_duration	=> pulse_length(pulse_length'high downto 3),
                
		-- trap_slope	=> tx_ctrl.window_slope,
                -- trap_slope controlls how fast the window funtion ramps to max pwm value
                -- And Should not exceed the pulselength
		-- trap_slope	=> x"0008bcf6", -- The total ramp up window length (corresponds to 9.5ms). ctrl_trap_slope (572662)
                trap_slope	=> ctrl_trap_slope, 
                
		window_done	=> window_done,
		window_valid	=> window_valid,
		wind_data	=> wind_data
	);


	c_mult : entity work.tx_mult(rtl)        
	generic map(
		G_DATA_WIDTH	=> C_MULT_DATA_WIDTH
	)
	port map(
		clk		=> clk,
		rst_n		=> rst_n,
		pwm_width	=> pwm_width,
                apz		=> '1' & x"00",
		wind_valid	=> window_valid,
		wind_data	=> wind_data,
		pwm_w_valid	=> pwm_w_valid,
		pwm_width_scl	=> pwm_width_scaled
	);
        
        c_pwm : entity work.tx_pwm(rtl)
	port map(
		clk		=> clk,
		rst_n		=> rst_n,
		pwm_w_valid	=> pwm_w_valid,
		smp_tick	=> pulse_valid,
                pulse_high	=> pulse_data(pulse_data'high),
                pwm_width	=> pwm_width_scaled,
                pwm_p		=> pwm_p,
                pwm_n		=> pwm_n
		
	);



	p_misc : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			pwm_active	<= '0';
			pwm_active_i	<= '0';
			window_done_d	<= '0';

		elsif rising_edge(clk) then
			window_done_d	<= window_done;
			start_d	        <= start;
                        start_dd	<= start_d;
			start_ddd	<= start_dd;

			-- for PWR board charge enable
			-- charging is enabled between last pulse sent and next ping's first pulse
			if window_done = '1' and window_done_d = '0' then
				pwm_active_i	<= '0';
			end if;

			if (start_ddd = '1') then
				pwm_active_i	<= enable_ch;
			end if;
			

			if smp_tick = '1' then
				pwm_active	<= pwm_active_i;
			end if;

			if param_valid.ctrl = '1' then
                                delay_mode	<= '0';
                                pulse_gen_mode	<= (others => '0');
                                window_mode	<= '0';
			end if;
		end if;

	end process p_misc;

end architecture str;
