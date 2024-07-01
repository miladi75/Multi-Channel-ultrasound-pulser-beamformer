
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity pulser_stx_top is
	port(
		
		-- Clocks and reset
		CLOCK_50_B7A	:  in std_logic;			-- Reference clock for pll_50 => 120MHz
                CPU_KEY_RST_N   : in std_logic;
		PWM1		: out std_logic_vector(15 downto 0);	-- PWM signal for pulser circuits + (##TODO - Add constant in package)
		PWM2		: out std_logic_vector(15 downto 0);
					
		UART_RX		:  in std_logic := '1';			-- Defualt or IDLE value of UART
		UART_TX		: out std_logic;			
		LEDR		: out unsigned(3 downto 0);	
                -- KEY		: in std_logic_vector(3 downto 0);	
		START_TX_TIMER_DEBUG	: out std_logic
		
	);
end entity pulser_stx_top;

-- 
-- 4c:d5:77:e4:e1:99
architecture str of pulser_stx_top is

        constant C_BAUD_RATE 	        : positive := 115200;
        constant C_CLK_HZ 	        : integer  := 120e6;
        constant C_NR_Tx_CHANS 	        : positive := 15;
        -- signal  C_CUSTOM_DELAY_VAL     : unsigned := to_unsigned(42, 20); 
	
	signal clk			: std_logic;
	signal rst_n			: std_logic;

        signal tx_trigger		: std_logic;
        signal tx_start			: std_logic;
        signal tx_start_d		: std_logic;
        signal cnt_delay		: std_logic_vector(19 downto 0);
        signal pulse_length		: std_logic_vector(22 downto 0);
        

	
        signal trigger_rate             : std_logic_vector(25 downto 0);
        signal pwm_width		: std_logic_vector(12 downto 0);
        signal enable_ch		: std_logic_vector(C_NR_Tx_CHANS downto 0);
        signal pwm1_i			: std_logic_vector(C_NR_Tx_CHANS downto 0);
        signal pwm2_i			: std_logic_vector(C_NR_Tx_CHANS downto 0);
        
        signal charge_en_n		: std_logic_vector(15 downto 0) := (others => '0');

        

	
        signal trig_pwr_i		: std_logic;

        signal reg_trigger_rate         : std_logic_vector(25 downto 0);
        signal ctrl_custom_delay        : unsigned(19 downto 0);

        signal ctrl_ping_rate           : std_logic_vector(25 downto 0);
        signal ctrl_pulse_length        : std_logic_vector(22 downto 0);
        signal ctrl_pwm_width           : std_logic_vector(12 downto 0);
        
        signal ctrl_start_slope         : std_logic_vector(11 downto 0);
        signal ctrl_slope_rate          : std_logic_vector(19 downto 0);
        signal ctrl_trap_slope          : std_logic_vector(31 downto 0);
        
        

begin

	-- For debugging and seeing the tx_trigtx_start in Saleae logic analyzer
        START_TX_TIMER_DEBUG <= tx_start;
        -- rst_n <= KEY(0);

        -- chan_enable <= chan_enable_i;

	trig_pwr_i	<= '1' when unsigned(charge_en_n) = 0 else '0';

	-- Clock and reset generation
	c_clk_rst_gen : entity work.clk_rst_gen(str)
	port map(
		refclk	=> CLOCK_50_B7A,
		clk	=> clk,
		rst_n	=> rst_n
	);

	c_timer : entity work.time_ctrl(rtl)
	port map(
		clk		=> clk,
		rst_n		=> rst_n,
                -- trigger_rate    => std_logic_vector(to_unsigned(2400000, 26)), -- for a 20 ms(50Hz) trigger rate
                -- trigger_rate    => std_logic_vector(to_unsigned(reg_trigger_rate, 26)), -- for a 20 ms(50Hz) trigger rate
                trigger_rate    => ctrl_ping_rate,
		cnt_delay	=> cnt_delay,
		tx_start	=> tx_start
                
	);


	-- last_pulse <= '1' when unsigned(pulse_id) = unsigned(num_pulses) else '0';
        -- pulse_valid <= '1' when unsigned(pulse_length) > 0 else '0';


	g_tx_ctrl : for ch in 0 to C_NR_Tx_CHANS generate
		c_tx_ctrl : entity work.tx_core(str)
		generic map(
			G_CH		=> ch
		)
		port map(
			clk		        => clk,
			rst_n		        => rst_n,
			-- enable		        => enable_ch(ch),  
                        enable		        => '1',  
			start		        => tx_start,
			cnt_delay	        => cnt_delay,
                        
                        
                        pulse_length            => ctrl_pulse_length, 
                        pwm_width	        => ctrl_pwm_width,
                        ctrl_custom_delay       => ctrl_custom_delay, 
                        
                        ctrl_start_slope        => ctrl_start_slope,
                        ctrl_slope_rate         => ctrl_slope_rate,
                        
                        ctrl_trap_slope         => ctrl_trap_slope,
                        
			pwm_p		        => pwm1_i(ch),
			pwm_n		        => pwm2_i(ch),
			pwm_active	        => charge_en_n(ch)
                        -- pulse_length            => std_logic_vector(to_unsigned(600000, 23)), -- 120e6 clk and pulse length (x"927C0") => 10 ms 
                        -- ctrl_custom_delay       => to_unsigned(42, 20), --C_CUSTOM_DELAY_VAL
                        -- pwm_width	        => std_logic_vector(to_unsigned(27, 13)),
                        -- ctrl_trap_slope         => std_logic_vector(to_unsigned(120000, 32)),
                        -- ctrl_start_slope        => std_logic_vector(to_unsigned(1048, 12)),
                        -- ctrl_slope_rate         => std_logic_vector(to_unsigned(305, 20)),
		);

		PWM1(ch) <= pwm1_i(ch);

		PWM2(ch) <= pwm2_i(ch);
		

	end generate g_tx_ctrl;

	
	

          
        inst_UART_IF : entity work.uart_interface(rtl)
        generic map (
          clk_hz => C_CLK_HZ
        )
        port map (
          clk                   => clk,
          rst_n                 => rst_n,
          uart_rx               => uart_rx,
          uart_tx               => uart_tx,
          LEDR                  => LEDR,
          ctrl_ping_rate        => ctrl_ping_rate,
          ctrl_pulse_length     => ctrl_pulse_length,
          ctrl_pwm_width        => ctrl_pwm_width,
          ctrl_custom_delay     => ctrl_custom_delay,
          ctrl_start_slope      => ctrl_start_slope,
          ctrl_slope_rate       => ctrl_slope_rate,
          ctrl_trap_slope       => ctrl_trap_slope
        );
        
	
end architecture str;
