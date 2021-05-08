----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia 
-- 
-- Create Date: 29.03.2021 16:31:57
-- Design Name: 
-- Module Name: blink_module - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

entity blink_module is
    Port ( clk   : in STD_LOGIC;
           pulse : in STD_LOGIC; 
           sel   : in STD_LOGIC_VECTOR (3 downto 0);
           xin   : in STD_LOGIC_VECTOR (7 downto 0);
           yout  : out STD_LOGIC_VECTOR (7 downto 0));
end blink_module;

architecture Behavioral of blink_module is
      
begin

    process(clk)
    begin
        
        if (rising_edge(clk)) then
            if (sel(0) = '0') then
                yout <= xin;
            elsif (sel(0) = '1') then
                if (pulse = '1') then
                    yout <= xin;
                elsif (pulse = '0') then
                    yout <= (others => '1');
                end if;
            end if;
        end if;
    end process;

end Behavioral;
