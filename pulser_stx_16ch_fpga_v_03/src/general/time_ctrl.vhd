-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Seyed and Gergely
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description:  generate tx_start and cnt_delay for time_ctrl
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;



entity time_ctrl is
	port(
		clk		:  in std_logic;			
		rst_n		:  in std_logic;			
		trigger_rate	:  in std_logic_vector(25 downto 0);	
                cnt_delay	: out std_logic_vector(19 downto 0);	-- Counter generated for delaying
		tx_start	: out std_logic			        -- Start signals towards TX control blocks.
		
	);
end entity time_ctrl;

architecture rtl of time_ctrl is
        
        signal tx_start_i	        : std_logic;
	signal cnt_delay_i	        : unsigned(19 downto 0);
	signal cnt_trig_i               : natural := 0;
        -- constant C_TRIG_LENGTH_20MS     : natural := 2400000; -- Corresponds to 20ms at 120MHz
	

begin

  

        
	tx_start	<= tx_start_i;
	
        cnt_delay	<= std_logic_vector(cnt_delay_i);
	


        proc_TX_START : process(clk, rst_n) is
                begin
                        if rst_n = '0' then
                                cnt_trig_i 	        <= 0; 
                                tx_start_i           <= '0';
                        elsif rising_edge(clk) then
                                
                                tx_start_i <= '0';

                                if cnt_trig_i = 0 then
                                        tx_start_i <= '1';
                                end if;
                                
                                if cnt_trig_i >= unsigned(trigger_rate) - 1 then 
                                        cnt_trig_i <= 0;
                                else
                                        cnt_trig_i <= cnt_trig_i + 1;
                                end if;
                                
                        end if;
                end process proc_TX_START;



	-- Process : proc_START_TX
	proc_START_TX : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			
			cnt_delay_i	<= (others => '0');

		elsif rising_edge(clk) then
			
                        -- When tx_start is initiated then count the delay of pulse
			if tx_start_i = '1' then
				cnt_delay_i	<= (others => '0');
			else
				cnt_delay_i	<= cnt_delay_i + 1;
			end if;
		end if;
	end process proc_START_TX;



end architecture rtl;
       