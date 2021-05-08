----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2021 17:25:19
-- Design Name: 
-- Module Name: Counter_1b - Behavioral
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

entity Counter_1b is
    Port ( clk    : in STD_LOGIC;
           enable : in STD_LOGIC;
           count  : out STD_LOGIC);
end Counter_1b;

architecture Behavioral of Counter_1b is
    signal s_count : unsigned(count'range);
begin


end Behavioral;
