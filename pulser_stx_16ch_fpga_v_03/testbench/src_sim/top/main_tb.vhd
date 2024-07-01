-- Taken from VHDLWhiz.com to test differnet testbench desgin
-- Not used in the thesis project and is therefor only to see in simulation



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity main_tb is
end main_tb;

architecture sim of main_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  -- Transmitter signals
  signal tx_in_word : std_logic_vector(31 downto 0) := (others => '0');
  signal tx_in_word_valid : std_logic := '0';
  signal tx_out_serial : std_logic;
  signal tx_out_serial_valid : std_logic;

  -- Receiver signals
  signal rx_in_serial : std_logic := '0';
  signal rx_in_serial_valid : std_logic := '0';
  signal rx_out_word : std_logic_vector(31 downto 0);
  signal rx_out_word_valid : std_logic;

  -- The number of bits in a transmitted word
  signal transmit_clk_cycles : natural;

  signal bit_flip_active : boolean;
  signal bit_flip_index : integer;

  -- Record for storing test results
  type res_type is record
    test_count : natural;
    fail_count : natural;
  end record;

  -- Results from different test types
  signal res_dummy : res_type;
  signal res_no_error_injection : res_type;
  signal res_single_bitflip : res_type;

  procedure print(msg : string; timestamp : boolean := true) is
    variable l : line;
  begin
    if timestamp then
      write(l, to_string(now) & " - " );
    end if;
    write(l, msg);
    writeline(output, l);
  end procedure;

  function pass_str(res : res_type) return string is
  begin
    if res.test_count = 0 then
      return "NO TESTS RAN";
    elsif res.fail_count = 0 then
      return "PASS (" & to_string(res.test_count) & " tests)";
    end if;

    return "FAIL (Failed " & to_string(res.fail_count) &
      " of " & to_string(res.test_count) & " tests)";
  end function;

begin

  clk <= not clk after clk_period / 2;

  TRANSMITTER_INST : entity work.transmitter(rtl)
    port map (
      clk => clk,
      rst => rst,
      in_word => tx_in_word,
      in_word_valid => tx_in_word_valid,
      out_serial => tx_out_serial,
      out_serial_valid => tx_out_serial_valid
    );

  BITFLIP_INST_1 : entity work.err_inject_bitflip(sim)
    port map (
      clk => clk,
      in_serial => tx_out_serial,
      in_serial_valid => tx_out_serial_valid,
      bit_flip_active => bit_flip_active,
      bit_flip_index => bit_flip_index,
      out_serial => rx_in_serial,
      out_serial_valid => rx_in_serial_valid
    );

  RECEIVER_INST : entity work.receiver(rtl)
    port map (
      clk => clk,
      rst => rst,
      in_serial => rx_in_serial,
      in_serial_valid => rx_in_serial_valid,
      out_word => rx_out_word,
      out_word_valid => rx_out_word_valid
    );
  
  -- For counting the number of bits in a transmitted word initially
  BIT_COUNTER_PROC : process
  begin
    wait until tx_out_serial_valid = '1';

    loop
      wait until rising_edge(clk);
      if tx_out_serial_valid /= '1' then
        exit;
      end if;

      transmit_clk_cycles <= transmit_clk_cycles + 1;
    end loop;

    print("Found encoded word length to be " & to_string(transmit_clk_cycles) & " bits");

    -- Pause this process forever. Only count the first word's bits
    wait;
  end process;
  
  SEQUENCER_PROC : process

    procedure test(
      constant word : in std_logic_vector(31 downto 0);
      signal res : inout res_type -- Test result counters to be incremented
      ) is
        constant timeout_time : time := clk_period * 200;
    begin
      wait for clk_period * 50;

      print("Send word x""" & to_hstring(word) & """");

      tx_in_word <= word;
      tx_in_word_valid <= '1';
      wait for clk_period;
      tx_in_word_valid <= '0';

      wait until rx_out_word_valid = '1' for timeout_time;

      res.test_count <= res.test_count + 1;
      
      if rx_out_word_valid /= '1' then
        res.fail_count <= res.fail_count + 1;
        report "Testbench timeout while waiting for the receiver output after "
          & to_string(timeout_time)
        severity failure;
      end if;

      if rx_out_word = word then
        print("Recv word x""" & to_hstring(rx_out_word) & """ (OK)");
      else
        res.fail_count <= res.fail_count + 1;
        report "Receiver output doesn't match expected word " & LF
          & "  rx_out_word: x""" & to_hstring(rx_out_word) & """" & LF
          & "  Expected:    x""" & to_hstring(word) & """"
        severity warning;
      end if;

      wait for clk_period * 50;
    end procedure;

  begin

    wait for clk_period * 2;

    rst <= '0';
    
    print(LF & "** Initial test testing to determine transmit_clk_cycles", false);
    test(x"80000001", res_dummy);

    print(LF & "** Tests without error injection", false);
    test(x"FFFFFFFF", res_no_error_injection);
    test(x"00000000", res_no_error_injection);
    test(x"AAAAAAAA", res_no_error_injection);
    test(x"55555555", res_no_error_injection);
    test(x"FF00FF00", res_no_error_injection);
    test(x"00FF00FF", res_no_error_injection);
    test(x"01234567", res_no_error_injection);
    test(x"89ABCDEF", res_no_error_injection);
    test(x"80000001", res_no_error_injection);
    test(x"7FFFFFFE", res_no_error_injection);

    print(LF & "** Testing single bit flips", false);
    for i in 0 to transmit_clk_cycles - 1 loop

      -- Tell BITFLIP_INST_1 to flip bit number i
      bit_flip_active <= true;
      bit_flip_index <= i;

      test(x"AA001155", res_single_bitflip);

      bit_flip_active <= false;
      wait for clk_period * 10;

    end loop;

    wait for 0 ns;
    print(LF & "** Testbench done", false);
    print("Without error injection: " & pass_str(res_no_error_injection));
    print("Single bit flip test:    " & pass_str(res_single_bitflip));

    finish;
  end process;

end architecture;