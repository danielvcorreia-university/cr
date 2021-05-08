--------------------------------------------
-- Module Name: decoder4_16_tl
--------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY UNISIM;
USE UNISIM.VComponents.all;

ENTITY decoder4_16_tl IS
	PORT (data_in  : IN  STD_LOGIC_VECTOR(4 downto 0);
	      data_out : OUT STD_LOGIC_VECTOR(15 downto 0));
END decoder4_16_tl;

ARCHITECTURE structure decoder4_16_tl IS

	COMPONENT decoder4_16
		PORT ( sw  : IN  STD_LOGIC_VECTOR(4 downto 0);
      		       led : OUT STD_LOGIC_VECTOR(15 downto 0));
	END COMPONENT;

BEGIN

-- decoder 4 to 16 with enable (sw(4))
data_out(15) <= data_in(15);
data_out(14) <= data_in(14);
data_out(13) <= data_in(13);
data_out(12) <= data_in(12);
data_out(11) <= data_in(11);
data_out(10) <= data_in(10);
data_out(9)  <= data_in(9);
data_out(8)  <= data_in(8);
data_out(7)  <= data_in(7);
data_out(6)  <= data_in(6);
data_out(5)  <= data_in(5);
data_out(4)  <= data_in(4);
data_out(3)  <= data_in(3);
data_out(2)  <= data_in(2);
data_out(1)  <= data_in(1);
data_out(0)  <= data_in(0);

-- structure
dec : decoder4_16 PORT MAP (data_in,
					data_out);

END structure;