library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder4_16 is
    Port ( enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end decoder4_16;

architecture Behavioral of decoder4_16 is

begin
    ger_out: for i in data_out'range generate
        data_out(i) <= enable when (i = to_integer(unsigned(data_in)))
                        else '0';
    end generate;
    
end Behavioral;
