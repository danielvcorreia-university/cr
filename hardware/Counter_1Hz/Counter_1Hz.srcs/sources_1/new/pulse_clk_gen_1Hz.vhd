----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 29.03.2021 00:40:16
-- Design Name: 
-- Module Name: pulse_clk_gen_1Hz - Behavioral
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

entity pulse_clk_gen_1Hz is
    Port ( clk         : in STD_LOGIC;
           reset       : in STD_LOGIC;
           clk_out_1Hz : out STD_LOGIC;
           pulse       : out STD_LOGIC);
end pulse_clk_gen_1Hz;

architecture Behavioral of pulse_clk_gen_1Hz is
    constant MAX : natural := 100_000_000;
    signal s_cnt : natural range 0 to MAX-1;
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            pulse <= '0';
            clk_out_1Hz <= '0';
            if (reset = '1') then
                s_cnt <= 0;
            else
                s_cnt <= s_cnt + 1;
                if (s_cnt > ((MAX/2)-1)) then
                    clk_out_1Hz <= '1';
                end if;
                if (s_cnt = MAX-1) then
                    s_cnt <= 0;
                    pulse <= '1';
                    clk_out_1Hz <= '1';                
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;