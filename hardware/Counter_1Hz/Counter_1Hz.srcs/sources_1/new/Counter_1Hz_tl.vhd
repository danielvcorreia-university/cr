----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 24.03.2021 08:54:19
-- Design Name: 
-- Module Name: Counter_1Hz_tl - Behavioral
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

entity Counter_1Hz_tl is
    Port ( clk    : in STD_LOGIC;
           btnC   : in STD_LOGIC;
           led    : out STD_LOGIC_VECTOR (3 downto 0));
end Counter_1Hz_tl;

architecture Structure of Counter_1Hz_tl is

    signal s_en, s_reset : STD_LOGIC;

    component pulse_generator_1Hz
		Port ( clk    : in  STD_LOGIC;
		       reset  : in  STD_LOGIC;
      		   pulse  : out STD_LOGIC);
	end component; 
	
	component Counter_4b
		Port ( clk    : in  STD_LOGIC;
		       reset  : in  STD_LOGIC;
      		   enable : in STD_LOGIC;
      		   count  : out STD_LOGIC_VECTOR (3 downto 0));
	end component;
begin

-- register asynchronous inputs
process(clk)
begin
    if (rising_edge(clk)) then
        s_reset <= btnC;
    end if;
end process;

    pulse_gen_1Hz : pulse_generator_1Hz PORT MAP ( clk, s_reset,
                                                    s_en);
                                                    
    counter : Counter_4b PORT MAP ( clk, s_reset, s_en,
                                                    led);

end Structure;
