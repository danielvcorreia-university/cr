----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2021 00:36:45
-- Design Name: 
-- Module Name: pulse_clock_gen_1Hz - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_clock_gen_1Hz is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           pulse : out STD_LOGIC);
end pulse_clock_gen_1Hz;

architecture Behavioral of pulse_clock_gen_1Hz is

begin


end Behavioral;
