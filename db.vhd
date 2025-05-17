library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Entity declaration for debounce module
entity db is
    Port ( clk 	: in   STD_LOGIC; -- Clock input
           btn_in : in   STD_LOGIC; -- Raw (possibly bouncing) button signal
           db 		: out  STD_LOGIC  -- Debounced button output
			 );
end db;
architecture Behavioral of db is
	constant max: integer := 50000000; -- Maximum count for debounce time (~1 second for 50MHz clock)
begin
	process(clk)
		variable count: integer range 0 to max := 0; -- Counter for debounce timing
		variable btn_prev: std_logic := '0';         -- Stores previous button state
	begin
		if rising_edge(clk) then
			-- Check if button state has changed and debounce is not in progress
			if btn_in /= btn_prev and count = 0 then
				db <= btn_in;
				btn_prev := btn_in;
				count := 1;
			end if;
			-- If debounce timer is running
			if count > 0 then
				count := count + 1; -- Increment debounce counter
				if count > max then
					count := 0;      -- Reset counter after debounce period ends
				end if;
			end if;
		end if;
	end process;
end Behavioral;

