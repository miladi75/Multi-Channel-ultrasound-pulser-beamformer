
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity uart_interface is
        generic (
          clk_hz : positive;
          baud_rate : positive := 115200
        );
        port (
          clk : in std_logic;
          rst_n : in std_logic;
      
          uart_rx : in std_logic;
          uart_tx : out std_logic;
      
          -- UART accessible registers
          LEDR : out unsigned(3 downto 0);
          ctrl_ping_rate : out std_logic_vector(25 downto 0);
          ctrl_pulse_length : out std_logic_vector(22 downto 0);
          ctrl_pwm_width : out std_logic_vector(12 downto 0);
          ctrl_custom_delay : out unsigned(19 downto 0);
          ctrl_start_slope : out std_logic_vector(11 downto 0);
          ctrl_slope_rate : out std_logic_vector(19 downto 0);
          ctrl_trap_slope : out std_logic_vector(31 downto 0)
          
          
        );
end uart_interface;
      

architecture rtl of uart_interface is

        signal out_regs         : std_logic_vector(151 downto 0);
        constant C_NR_BYTES     : natural := 19;
        
      
begin
      
        ctrl_trap_slope <= out_regs(151 downto 120);
        ctrl_slope_rate <= out_regs(119 downto 100);
        ctrl_start_slope <= out_regs(99 downto 88);
        ctrl_custom_delay <= unsigned(out_regs(87 downto 68));
        ctrl_pwm_width <= out_regs(67 downto 55);
        ctrl_pulse_length <= out_regs(54 downto 32);
        ctrl_ping_rate <= out_regs(31 downto 6);
        LEDR <= unsigned(out_regs(5 downto 2));

        insta_UART_CTRL : entity work.uart_fsm(rtl)
                generic map (
                        clk_hz => clk_hz, baud_rate => baud_rate, in_bytes => 0,
                        out_bytes => C_NR_BYTES
                )
                port map (clk => clk, rst_n => rst_n, uart_rx => uart_rx, uart_tx => uart_tx, ctrl_in_regs => "",
                ctrl_out_regs => out_regs );
      
end architecture;