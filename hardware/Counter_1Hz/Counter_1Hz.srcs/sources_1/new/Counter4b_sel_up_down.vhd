----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 28.03.2021 18:28:22
-- Design Name: 
-- Module Name: Counter4b_sel_up_down - Behavioral
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

entity Counter_4b_sel_up_down is
    Port ( clk       : in STD_LOGIC;
           reset     : in STD_LOGIC;
           enable    : in STD_LOGIC;  
           increment : in STD_LOGIC;
           decrement : in STD_LOGIC;
           sel       : in STD_LOGIC_VECTOR(3 downto 0);
           count     : out STD_LOGIC_VECTOR (3 downto 0));
end Counter_4b_sel_up_down;

architecture Behavioral of Counter_4b_sel_up_down is
    signal s_count : unsigned(count'range);
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                s_count <= (others => '0');
            elsif (enable = '1') then
                if (sel(0) = '0') then
                    s_count <= s_count + 1;
                elsif (sel(0) = '1') then
                    if (increment = '1') then
                        s_count <= s_count + 1;
                    elsif (decrement = '1') then
                        s_count <= s_count - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    count <= std_logic_vector(s_count);
    
end Behavioral;
