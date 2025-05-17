library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Entity definition for a 4-bit ALU
entity alu is
    Port ( clk    : in   STD_LOGIC; 						 -- Clock signal
           op     : in   STD_LOGIC_VECTOR(2 downto 0); -- Operation selector (3-bit)
           num_1  : in   STD_LOGIC_VECTOR(3 downto 0); -- First 4-bit operand
           num_2  : in   STD_LOGIC_VECTOR(3 downto 0); -- Second 4-bit operand
           result : out  STD_LOGIC_VECTOR(7 downto 0)  -- Output: flags + 4-bit result
			 );
end alu;

architecture hardware of alu is
begin

	process(clk)
		-- Internal variables
		variable num_1_sig, num_2_sig : signed(3 downto 0); 				-- Signed versions of operands
		variable extend_sum           : signed(4 downto 0); 				-- For extended result (to detect carry)
		variable result_reg				 : std_logic_vector(3 downto 0); -- 4-bit result register
		variable c_out                : std_logic; 							-- Carry-out flag
		variable negative				 : std_logic; 								-- Negative flag
		variable zero						 : std_logic; 							-- Zero flag
		variable overflow				 : std_logic; 								-- Overflow flag
		variable shift_reg				 : std_logic_vector(7 downto 0); -- For storing shifted result
		variable shift					 : integer range 0 to 3;				-- Amount of shift
	begin
		if rising_edge(clk) then
			case op is
				when "000" => -- ADDITION
				
					-- Convert to signed
					num_1_sig := signed(num_1); 
					num_2_sig := signed(num_2);
		
					extend_sum := ('0' & num_1_sig) + ('0' & num_2_sig); -- Perform signed addition with extended width
					result_reg := std_logic_vector(extend_sum(3 downto 0));
					c_out      := extend_sum(4);
					negative   := extend_sum(3);
					if extend_sum(3 downto 0) = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					if (num_1_sig(3) = num_2_sig(3)) and (extend_sum(3) /= num_1_sig(3)) then  --flag de overflow
						overflow := '1';
					else 
						overflow := '0';
					end if;
				when "001" => -- SUBTRACTION
				
					-- Convert to signed
					num_1_sig := signed(num_1);
					num_2_sig := signed(num_2);
					
					extend_sum := ('0' & num_1_sig) - ('0' & num_2_sig);
					result_reg := std_logic_vector(extend_sum(3 downto 0));
					c_out 	  := extend_sum(4);
					negative   := extend_sum(3);
					if extend_sum(3 downto 0) = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					if (num_1_sig(3) /= num_2_sig(3)) and (extend_sum(3) /= num_1_sig(3)) then
						overflow := '1';
					else 
						overflow := '0';
					end if;
					
				when "010" => -- BITWISE AND

					result_reg := num_1 AND num_2;
					c_out 	  := '0';
					negative   := result_reg(3);
					if result_reg = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					overflow := '0';
					
				when "011" => -- BITWISE OR
				
					result_reg := num_1 OR num_2;
					c_out 	  := '0';
					negative   := result_reg(3);
					if result_reg = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					overflow := '0';
					
				when "100" => -- BITWISE XOR
				
					result_reg := num_1 XOR num_2;
					c_out 	  := '0';
					negative   := result_reg(3);
					if result_reg = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					overflow := '0';
				
				when "101" => -- COMPARATOR
				
					if num_1 = num_2 then
						result_reg := "0001";
					elsif num_1 < num_2 then
						result_reg := "0010";
					elsif	num_1 > num_2 then
						result_reg := "0011";
					end if;
					c_out := '0';
					negative := '0';
					zero := '0';
					overflow := '0';
					
				when "110" => -- LOGICAL SHIFT LEFT
				
					if to_integer(unsigned(num_2)) > 3 then
						shift := 3;
					else
						shift := to_integer(unsigned(num_2));
					end if;
					
					shift_reg := std_logic_vector(shift_left(unsigned(num_1 & "0000"), shift));
					result_reg := shift_reg(7 downto 4);
					c_out := '0';
					negative := result_reg(3);
					if result_reg = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					overflow := '0';
						
				when others => -- LOGICAL SHIFT RIGHT
					if to_integer(unsigned(num_2)) > 3 then
						shift := 3;
					else
						shift := to_integer(unsigned(num_2));
					end if;
					
					shift_reg := std_logic_vector(shift_right(unsigned("0000" & num_1), shift));
					result_reg := shift_reg(3 downto 0);
					c_out := '0';
					negative := result_reg(3);
					if result_reg = "0000" then
						zero := '1';
					else
						zero := '0';
					end if;
					overflow := '0';
					
			end case;
		end if;
		-- Combine flags and result into one 8-bit output
		result <= overflow & zero & negative & c_out & result_reg(3 downto 0);
	end process;
end hardware;

