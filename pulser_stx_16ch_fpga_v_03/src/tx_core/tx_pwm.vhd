
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi and Seyed Husseini
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description: tx_pwm drives the pwm_p and pwm signals
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity tx_pwm is
	port(
		clk		:  in std_logic;			-- Clock
		rst_n		:  in std_logic;			-- Reset
		pwm_w_valid	:  in std_logic;			--
		smp_tick	:  in std_logic;			-- 60 MHz sample tick
                pulse_high	:  in std_logic;			--
                pwm_width	:  in std_logic_vector(12 downto 0);	--
		pwm_p		: out std_logic;			--
		pwm_n		: out std_logic				--
	);
end entity tx_pwm;


architecture rtl of tx_pwm is


	
        signal pwm_width_d	: std_logic_vector(pwm_width'range);
        signal cnt_duty_cycle		: unsigned(12 downto 0);
        signal pwm_p_i		: std_logic;
        signal pwm_n_i		: std_logic;
        signal pulse_high_d	: std_logic;

begin

	pwm_p <= pwm_p_i;
	pwm_n <= pwm_n_i;


	p_ctrl : process(clk, rst_n) is
	begin
		if rst_n = '0' then
			-- pwm_cnt		<= (others => '0');
			-- pwm_len		<= (others => '0');
			cnt_duty_cycle		<= (others => '1');
			pwm_width_d	<= (others => '0');
			-- thresh_p	<= (others => (others => '0'));
			-- thresh_n	<= (others => (others => '0'));
			pwm_p_i		<= '0';
			pwm_n_i		<= '0';
			-- smp_tick_d	<= '0';
			-- pulse_hi	<= '0';
			pulse_high_d	<= '0';

		elsif rising_edge(clk) then

			-- smp_tick_d <= smp_tick;

			if smp_tick = '1' then
				pulse_high_d <= pulse_high;
			end if;

			if pwm_w_valid = '1' then
				pwm_width_d <= pwm_width;
			end if;

			if smp_tick = '1' and pulse_high_d /= pulse_high then
				cnt_duty_cycle <= (others => '0');
			end if;

			if cnt_duty_cycle = unsigned(pwm_width_d) then
				cnt_duty_cycle	<= (others => '1');

			elsif cnt_duty_cycle < unsigned(pwm_width_d) then
				cnt_duty_cycle	<= cnt_duty_cycle + 1;
				pwm_p_i	<= not pulse_high;
				pwm_n_i	<= pulse_high;
			else
				pwm_p_i <= '0';
				pwm_n_i <= '0';
			end if;
		end if;
	end process p_ctrl;

end architecture rtl;
