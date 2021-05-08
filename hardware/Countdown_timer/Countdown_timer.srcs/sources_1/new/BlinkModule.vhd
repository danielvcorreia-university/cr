library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity BlinkModule is
    Port ( clk   : in STD_LOGIC;
           freq  : in STD_LOGIC;
           state : in STD_LOGIC_VECTOR (2 downto 0);
           xin   : in STD_LOGIC_VECTOR (7 downto 0);
           yout  : out STD_LOGIC_VECTOR (7 downto 0));
end BlinkModule;

architecture Behavioral of BlinkModule is

begin
process(clk)
    begin
        if rising_edge(clk) then
            if (state = "010") then
                if (freq = '1') then
                    yout <= xin;
                else
                    yout <= "11000111";
                end if;
            elsif (state = "011") then
                if (freq = '1') then
                    yout <= xin;
                else
                    yout <= "11001011";
                end if;
            elsif (state = "100") then
                if (freq = '1') then
                    yout <= xin;
                else
                    yout <= "11010011";
                end if;
            elsif (state = "101") then
                if (freq = '1') then
                    yout <= xin;
                else
                    yout <= "11100011";
                end if;
            else
                yout <= xin;
            end if;
        end if;
end process;
    
end Behavioral;
