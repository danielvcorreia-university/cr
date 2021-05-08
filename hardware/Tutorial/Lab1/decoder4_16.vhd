--------------------------------------------
-- Module Name: decoder4_16
--------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY UNISIM;
USE UNISIM.VComponents.all;

ENTITY decoder4_16 IS
PORT( sw    : IN  STD_LOGIC_VECTOR(4 downto 0);
      led   : OUT STD_LOGIC_VECTOR(15 downto 0));
END decoder4_16;

ARCHITECTURE behavioral OF decoder4_16 IS

SIGNAL s_led_array: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin
process (sw)
begin
	-- default input
	led <= s_led_array;
	
	if (sw(4) = '1') then
		case sw is 
			when "0000" => led(0)  <= '1';
			when "0001" => led(1)  <= '1';
			when "0010" => led(2)  <= '1';
			when "0011" => led(3)  <= '1';
			when "0100" => led(4)  <= '1';
			when "0101" => led(5)  <= '1';
			when "0110" => led(6)  <= '1';
			when "0111" => led(7)  <= '1';
			when "1000" => led(8)  <= '1';
			when "1001" => led(9)  <= '1';
			when "1010" => led(10) <= '1';
			when "1011" => led(11) <= '1';
			when "1100" => led(12) <= '1';
			when "1101" => led(13) <= '1';
			when "1110" => led(14) <= '1';
			when "1111" => led(15) <= '1';
			when others => led <= "1111111111111111";
		end case;
	end if;
end process;
end behavioral;