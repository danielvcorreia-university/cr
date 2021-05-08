----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 28.03.2021 19:14:16
-- Design Name: 
-- Module Name: mutex2_1 - Behavioral
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

entity mutex2_1 is
    Port ( a   : in STD_LOGIC;
           b   : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR(3 downto 0);
           y   : out STD_LOGIC);
end mutex2_1;

architecture Behavioral of mutex2_1 is
begin

    y <= b when (sel(0) = '1') else a;
    
end Behavioral;
