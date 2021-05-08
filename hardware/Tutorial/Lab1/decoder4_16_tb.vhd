--------------------------------------------
-- Module Name: decoder4_16_tb
--------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

USE STD.textio.all;
USE IEEE.std_logic_textio.all;

LIBRARY UNISIM;
USE UNISIM.VComponents.all;

ENTITY decoder4_16_tb IS
END decoder4_16_tb;

ARCHITECTURE behavioral OF decoder4_16_tb IS
	COMPONENT decoder4_16_tl IS
		PORT ( sw  : IN  STD_LOGIC_VECTOR(4 downto 0);
                       led : OUT STD_LOGIC_VECTOR(15 downto 0));
	END COMPONENT;

	SIGNAL s_sw  : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL s_led : STD_LOGIC_VECTOR(15 downto 0);

BEGIN

	dec: decoder4_16_tl PORT MAP ( sw => s_sw, 
							led => s_led);
	stim: process

	BEGIN

		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		s_sw <= "0000";
		wait for 20 ns;
		
		wait;

	END process;
END behavioral;