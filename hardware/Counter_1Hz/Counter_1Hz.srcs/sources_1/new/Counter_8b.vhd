----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2021 17:06:37
-- Design Name: 
-- Module Name: Counter_8b - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter_8b is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (7 downto 0));
end Counter_8b;

architecture Behavioral of Counter_8b is
    signal s_count : unsigned(count'range);
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                s_count <= (others => '0');
            elsif (enable = '1') then
                s_count <= s_count + 1;
            end if;
        end if;
    end process;
    
    count <= std_logic_vector(s_count);
    
end Behavioral;
