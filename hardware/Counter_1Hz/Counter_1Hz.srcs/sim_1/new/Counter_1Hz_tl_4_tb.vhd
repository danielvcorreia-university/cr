----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2021 19:59:05
-- Design Name: 
-- Module Name: Counter_1Hz_tl_4_tb - Behavioral
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

entity Counter_1Hz_tl_4_tb is
end Counter_1Hz_tl_4_tb;

architecture Behavioral of Counter_1Hz_tl_4_tb is
    component Counter_1Hz_tl_4
        Port ( clk  : in STD_LOGIC;
               btnC : in STD_LOGIC;
               btnR : in STD_LOGIC;
               btnU : in STD_LOGIC;
               btnD : in STD_LOGIC;
               led  : out STD_LOGIC_VECTOR(3 downto 0);
               an   : out STD_LOGIC_VECTOR(7 downto 0);
               seg  : out STD_LOGIC_VECTOR(6 downto 0));
    end component;
begin


end Behavioral;
