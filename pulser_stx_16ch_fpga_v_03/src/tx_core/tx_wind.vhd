
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi 
-- Edit/Modified: Seyed
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
--      Generate 8 bit trapezoid window function in the process proc_genTrapWind
--      Window duration is almost the same as total pulse length (somewhat less)
--      trap_slope decides how fast or slow the ramping effect will be on pwm
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;


entity tx_wind is
	port(
		clk				:  in std_logic;		
		rst_n			        :  in std_logic;			
		start_wind			:  in std_logic;			
		win_tick		        :  in std_logic;			
		wind_duration			:  in std_logic_vector(19 downto 0);	
		trap_slope		        :  in std_logic_vector(31 downto 0);	
		window_done			: out std_logic;			
		window_valid			: out std_logic;			
		wind_data			: out std_logic_vector(8 downto 0)	
	);
end entity tx_wind;


architecture rtl of tx_wind is

	-- Signal declarations

        constant C_WIND_VAL_ONE32	: unsigned(32 downto 0) := to_unsigned(2**(8+16), 33);
	constant C_DATA_CNT_MAX32	: unsigned(32 downto 0) := (32 => '1', others => '0');
	constant C_DATA_MAX	: std_logic_vector(wind_data'range) := std_logic_vector(to_unsigned(2**8, wind_data'length));
	
	
	signal valid_i		: std_logic;
	signal full_smp_cnt	: unsigned(wind_duration'range);
	
	
	signal data_cnt32	: unsigned(32 downto 0);
	signal slope_up		: std_logic;
	
	signal slope_down	: std_logic;
	
	signal hold_end_smp	: unsigned(wind_duration'range);
	signal length_mod	: unsigned(wind_duration'range);
	signal done_i		: std_logic;
	signal first		: std_logic;


begin
        window_done <= done_i;


        -- Process: proc_genTrapWind
	-- Generates 8 bit trapezoid window by
	-- incrementing the counter by 'slope_incr' at
	-- every 'slope_smp' sample until full value,
	-- and decrements until 0 at the pulse end based
	-- on the TX wind_duration parameter
	proc_genTrapWind : process (clk, rst_n) is
                begin
                        if rst_n = '0' then
                                full_smp_cnt	<= (others => '0');
                                data_cnt32	<= (others => '0');
                                hold_end_smp	<= (others => '1');
                                slope_up	<= '0';
                                
                                slope_down	<= '0';
                                valid_i		<= '0';
                                first		<= '0';
                                done_i		<= '1';
        
                        elsif rising_edge(clk) then
        
                                window_valid		<= valid_i;
                                valid_i		<= '0';
        
                                length_mod	<= unsigned(wind_duration) + 2;
        
                                if start_wind = '1' then
                                        done_i		<= '0';
                                        slope_up	<= '1';
                                        full_smp_cnt	<= (others => '0');
                                        --smp_cnt		<= (others => '0');
                                        hold_end_smp	<= (others => '1');
                                end if;
        
                                if data_cnt32 >= C_DATA_CNT_MAX32 then
                                        wind_data	<= C_DATA_MAX;
                                else
                                        wind_data	<= std_logic_vector(data_cnt32(32 downto 24));
                                end if;
        
        
                                if slope_up = '1' and data_cnt32 >= C_DATA_CNT_MAX32 then
                                        slope_up	<= '0';
                                        hold_end_smp	<= length_mod - full_smp_cnt;
                                end if;
        
                                if full_smp_cnt >= hold_end_smp then
                                        slope_down	<= not done_i;
                                end if;
        
                                if slope_down = '1' and data_cnt32 = C_WIND_VAL_ONE32 then
                                        slope_down	<= '0';
                                        done_i		<= '1';
                                        first		<= '0';
                                end if;
        
                                if win_tick = '1' and done_i = '0' then
        
                                        valid_i		<= '1';
                                        full_smp_cnt	<= full_smp_cnt + 1;
        
                                        if slope_up = '1' then
                                                data_cnt32	<= data_cnt32 + unsigned(trap_slope);
        
                                        elsif slope_down = '1' then
                                                data_cnt32	<= data_cnt32 - unsigned(trap_slope);
                                        end if;
        
                                        if first = '0' then
                                                first	<= '1';
                                                data_cnt32<= C_WIND_VAL_ONE32;
                                        end if;
                                end if;
        
                        end if;
                end process proc_genTrapWind;



end architecture rtl;
