-- Quartus II VHDL Template
-- Simple Dual-Port RAM with different read/write addresses but
-- single read/write clock

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scdpram is
	generic	(
		G_DATA_WIDTH	: natural := 8;
		G_ADDR_WIDTH	: natural := 6
	);
	port	(
		clk		:  in std_logic;
		raddr		:  in std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
		waddr		:  in std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
		data		:  in std_logic_vector(G_DATA_WIDTH - 1 downto 0);
		we		:  in std_logic := '1';
		q		: out std_logic_vector(G_DATA_WIDTH - 1 downto 0)
	);

end scdpram;

architecture rtl of scdpram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((G_DATA_WIDTH-1) downto 0);
	type memory_t is array(2**G_ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.
	signal ram 	: memory_t;
	signal q_i	: std_logic_vector((G_DATA_WIDTH-1) downto 0);

begin

  proc_RDWR_RAM: process(clk)
	begin
                if(rising_edge(clk)) then
                        if(we = '1') then
                                ram(to_integer(unsigned(waddr))) <= data;
                        end if;

                        -- On a read during a write to the same address, the read will
                        -- return the OLD data at the address
                        q_i 	<= ram(to_integer(unsigned(raddr)));
                        q 	<= q_i;
                end if;
	end process;

end rtl;
