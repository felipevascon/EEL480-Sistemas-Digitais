library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration of the state machine
entity state_machine is
    Port ( clk      : in   STD_LOGIC; -- Clock input
			  set_btn  : in   STD_LOGIC; -- Button input to change states
           switches : in   STD_LOGIC_VECTOR(3 downto 0); -- Input switches (4 bits)
           leds_out : out  STD_LOGIC_VECTOR(7 downto 0) := "00000000" -- LED output
			 );
end state_machine;

architecture Behavioral of state_machine is

	-- Declare the five states
	type state_type is(s0, s1, s2, s3, s4);

	-- Internal signals
	signal num_op     : std_logic_vector(2 downto 0); -- Operation code (3 bits)
	signal num_1      : std_logic_vector(3 downto 0); -- First operand (4 bits)
	signal num_2      : std_logic_vector(3 downto 0); -- Second operand (4 bits)
	signal debounced  : std_logic;						  -- Debounced button output
	signal alu_result : std_logic_vector(7 downto 0); -- ALU result (8 bits)
	
	-- Debounce component
	component db is
    Port ( clk 	: in   STD_LOGIC;
           btn_in : in   STD_LOGIC;
           db 		: out  STD_LOGIC
			 );
	end component;
	
	-- ALU component
	component alu is
    Port ( clk    : in   STD_LOGIC;
           op     : in   STD_LOGIC_VECTOR(2 downto 0);
           num_1  : in   STD_LOGIC_VECTOR(3 downto 0);
           num_2  : in   STD_LOGIC_VECTOR(3 downto 0);
           result : out  STD_LOGIC_VECTOR(7 downto 0)
			 );
	end component;
	
begin

	-- Instantiate debounce module
	db_label: db 
		port map(
					clk    => clk,
					btn_in => set_btn,
					db     => debounced
					);
					
	-- Instantiate ALU module
	alu_label: alu
		port map( 
					clk    => clk,
					op     => num_op,
					num_1  => num_1,
					num_2  => num_2,
					result => alu_result
					);
	
	-- State machine process
	process(clk, debounced, switches)
		variable deb_prev: std_logic := '0';
		variable current_state: state_type := s0;
	begin
		if rising_edge(clk) then
		
			-- Detect falling edge of button press (release)
			if debounced = '0' and deb_prev = '1' then
				deb_prev := '0';
			end if;
			
			-- Detect rising edge of button press (click)
			if debounced = '1' and deb_prev = '0' then
				deb_prev := '1';
				case current_state is
					when s0 => -- Load operation
						leds_out <= "00000001";
						current_state := s1;
						for i in 0 to 2 loop
							num_op(i) <= switches(i);
						end loop;
					when s1 => -- Load first number
						leds_out <= "00000010";
						current_state := s2;
						for i in 0 to 3 loop
							num_1(i) <= switches(i);
						end loop;
					when s2 =>  -- Load second number
						leds_out <= "00000011";
						current_state := s3;
						for i in 0 to 3 loop
							num_2(i) <= switches(i);
						end loop;
					when s3 => -- Show result on LEDs
						leds_out <= alu_result;
						current_state := s4;
					when s4 =>
						leds_out <= "00000000";
						current_state := s0;
				end case;
			end if;
		end if;	
	end process;
	
	--process(clk)
	--begin
		--if rising_edge(clk) then
			--current_state <= reg_state;
		--end if;
	--end process;

end Behavioral;

