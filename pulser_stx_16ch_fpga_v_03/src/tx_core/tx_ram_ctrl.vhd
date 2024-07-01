-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Author       : Gergely Ivanyi and Seyed Husseini
-- Company      : Norbit
-- Platform     : Altera Cyclone V
-- Standard     : VHDL'08
-------------------------------------------------------------------------------
-- Description: tx_ram_ctrl generates the valid and holds the delay values
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.types_pkg.all;

	


entity tx_ram_ctrl is

	port(
		clk		:  in std_logic;				
		rst_n		:  in std_logic;				
		enable		:  in std_logic;				
                start		:  in std_logic;				
                param_valid	: out param_valid_t				
				
	);
end entity tx_ram_ctrl;


architecture str of tx_ram_ctrl is
        -- subtype slv3_t is std_logic_vector(2 downto 0);
        -- subtype slv8_t is std_logic_vector(7 downto 0);
        -- subtype slv20_t is std_logic_vector(19 downto 0);
        -- subtype slv32_t is std_logic_vector(31 downto 0);
        
        -- type slv3_vector_t is array (natural range <>) of slv3_t;
        -- type slv8_vector_t is array (natural range <>) of slv8_t;
        -- type slv32_vector_t is array (natural range <>) of slv32_t;
        -- type slv20_vector_t is array (natural range <>) of slv20_t;

        signal raddr		: slv8_vector_t(0 to 1);
	signal rdata_i		: slv32_vector_t(0 to 1);
        signal rd_en		: std_logic;

        signal waddr		: std_logic_vector(7 downto 0);
        signal wdata		: std_logic_vector(31 downto 0);
        signal wdata_dly	: std_logic_vector(19 downto 0);

        signal raddr_dly	: slv3_vector_t(0 to 1);
        signal waddr_dly	: std_logic_vector(2 downto 0);
        
	signal wren_dly_i	: std_logic_vector(1 downto 0);
	signal rdata_dly_i	: slv20_vector_t(0 to 1);
        
        signal wren_i		: std_logic_vector(1 downto 0);
        
	signal start_d		: std_logic;
        constant C_RD_DELAY	: natural range 1 to 3 := 2;
        constant C_NUM_RD	: natural range 1 to 116 := 9; -- ctrl, dly, tri, sin, win, 4*thresh
	
	signal start_shr	: std_logic_vector(C_RD_DELAY - 1 downto 0);
	signal rd_start		: std_logic_vector(C_RD_DELAY downto 0);
	signal rd_valid		: std_logic_vector(C_NUM_RD - 1 downto 0);
	signal raddr_low	: unsigned(4 downto 0);
        
  

begin
        ----------------------------------------------------------------------------------------------
	-- Generate 2 RAM instantces for parameters and 2 for reading delay values
        ----------------------------------------------------------------------------------------------
        gen_ram : for i in 0 to 1 generate
        inst_RAM_INIT : entity work.scdpram(rtl)
        generic	map(
                G_DATA_WIDTH	=> 32,
                G_ADDR_WIDTH	=> 8
        )
        port map(
                clk		=> clk,
                we		=> wren_i(i),
                waddr		=> waddr,
                data		=> wdata,
                raddr		=> raddr(i),
                q		=> rdata_i(i)
        );

        inst_RAM_DELAY : entity work.scdpram(rtl)
        generic	map(
                G_DATA_WIDTH	=> 20, -- tx_ctrl_custom delay length
                G_ADDR_WIDTH	=> 3
        )
        port map(
                clk		=> clk,
                we		=> wren_dly_i(i),
                waddr		=> waddr_dly,
                data		=> wdata_dly,
                raddr		=> raddr_dly(i),
                q		=> rdata_dly_i(i)
        );
        end generate gen_ram;
        ----------------------------------------------------------------------------------------------


        ----------------------------------------------------------------------------------------------
        -------------------------------- Process : proc_READ_RAM -------------------------------------
	-- Reads parameter from RAM after start and set the correct valid 
        ----------------------------------------------------------------------------------------------
	proc_READ_RAM : process (clk, rst_n) is
                begin
                        if rst_n = '0' then
                                param_valid	<= param_valid_IDLE;
                                rd_start	<= (others => '0');
                                raddr_low	<= (others => '0');
                                rd_en		<= '0';
                                start_d		<= '0';
        
                        elsif rising_edge(clk) then
                                start_d		<= start;
                                start_shr	<= start_shr(start_shr'high - 1 downto 0) & start;
                                rd_valid	<= rd_valid(rd_valid'high - 1 downto 0) & start_d;
                                raddr_low	<= (others => '0');
        
                                param_valid.ctrl <= '0';
        
                                if enable = '1' and start = '1' then
                                        -- initialize the valdi_parameter to the IDLE 
                                        param_valid	<= param_valid_IDLE;
                                        rd_start(0)	<= '1';
                                        rd_en		<= '1';
                                        raddr_low	<= raddr_low + 1;
                                end if;
        
                                if rd_en = '1' then
                                        if raddr_low <= C_NUM_RD - 1 then
                                                raddr_low	<= raddr_low + 1;
                                        else
                                                rd_en		<= '0';
                                        end if;
                                end if;
        
                                if rd_valid(0) = '1' then
                                        param_valid.ctrl	<= '1';
                                        --tx_ctrl.apz           <= rdata_i(0)(8 downto 0);

                                end if;
                                
                                if rd_valid(1) = '1' then
                                        param_valid.custom_delay	<= '1';

                                end if;
                                -- Triangular pulse valid
                                if rd_valid(2) = '1' then
                                        param_valid.tri			<= '1';

                                end if;
                                -- Set Apodization/window function valid
                                if rd_valid(3) = '1' then
                                        param_valid.window		<= '1';

                                end if;
        
                        end if;
                end process proc_READ_RAM;
        ----------------------------------------------------------------------------------------------


end architecture str;