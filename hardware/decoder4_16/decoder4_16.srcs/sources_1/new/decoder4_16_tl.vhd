library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder4_16_tl is
    Port ( enable : in STD_LOGIC;
           sw     : in  STD_LOGIC_VECTOR (3 downto 0);
	       led    : out STD_LOGIC_VECTOR (15 downto 0));
end decoder4_16_tl;

architecture Structure of decoder4_16_tl is

    component decoder4_16
		Port ( enable   : in  STD_LOGIC;
		       data_in  : in  STD_LOGIC_VECTOR(3 downto 0);
      		   data_out : out STD_LOGIC_VECTOR(15 downto 0));
	end component; 

begin
dec : decoder4_16 PORT MAP (enable, sw,
                                    led);
                                    
end Structure;