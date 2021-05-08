library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder4_16_tb is
end decoder4_16_tb;

architecture Behavioral of decoder4_16_tb is
    component decoder4_16_tl
    port ( enable : in STD_LOGIC;
           sw     : in  STD_LOGIC_VECTOR (3 downto 0);
           led    : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    signal en        : STD_LOGIC := '1';
    signal switch    : STD_LOGIC_VECTOR(3 downto 0) := X"0";
    signal led_out   : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
    signal count_int : UNSIGNED(3 downto 0) := X"0";
           
begin
     
     decoder:   decoder4_16_tl PORT MAP ( enable => en,
                                          sw => switch,
                                          led => led_out);
                                       
     comb_process: process
     
     begin
            wait for 50 ns;
            switch <= STD_LOGIC_VECTOR(count_int);
            wait for 10 ns;
            count_int <= count_int + X"1";
            
     end process;
        
end Behavioral;
