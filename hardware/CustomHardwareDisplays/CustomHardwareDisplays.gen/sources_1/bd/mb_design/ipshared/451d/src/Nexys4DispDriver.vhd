library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nexys4DispDriver is
    Port ( clk     : in STD_LOGIC;
           enable  : in STD_LOGIC;
           en_L    : in STD_LOGIC_VECTOR(7 downto 0);  
           en_dp_L : in STD_LOGIC_VECTOR(7 downto 0); 
           hex0    : in STD_LOGIC_VECTOR(3 downto 0);
           hex1    : in STD_LOGIC_VECTOR(3 downto 0);
           hex2    : in STD_LOGIC_VECTOR(3 downto 0);
           hex3    : in STD_LOGIC_VECTOR(3 downto 0);
           hex4    : in STD_LOGIC_VECTOR(3 downto 0);
           hex5    : in STD_LOGIC_VECTOR(3 downto 0);
           hex6    : in STD_LOGIC_VECTOR(3 downto 0);
           hex7    : in STD_LOGIC_VECTOR(3 downto 0);
           an_L    : out STD_LOGIC_VECTOR(7 downto 0);
           seg_L   : out STD_LOGIC_VECTOR(6 downto 0);
           dp_L    : out STD_LOGIC);
end Nexys4DispDriver;

architecture Behavioral of Nexys4DispDriver is
    signal s_led_bcd : STD_LOGIC_VECTOR(4 downto 0);
    signal s_count : unsigned(2 downto 0);   
    signal s_seg_activate_count: STD_LOGIC_VECTOR(2 downto 0);

begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (enable = '1') then
                s_count <= s_count + 1;
            end if;            
        end if;
    end process;
    
    s_seg_activate_count <= std_logic_vector(s_count);
    
    process(s_seg_activate_count, en_dp_L, en_L)    
    begin
        case s_seg_activate_count is
            when "000"  => an_L <= x"FE"; s_led_bcd <= en_L(1) & hex7; dp_L <= en_dp_L(0);
            when "001"  => an_L <= x"FD"; s_led_bcd <= en_L(2) & hex6; dp_L <= en_dp_L(1);
            when "010"  => an_L <= x"FB"; s_led_bcd <= en_L(3) & hex5; dp_L <= en_dp_L(2);
            when "011"  => an_L <= x"F7"; s_led_bcd <= en_L(4) & hex4; dp_L <= en_dp_L(3);
            when "100"  => an_L <= x"EF"; s_led_bcd <= en_L(5) & hex3; dp_L <= en_dp_L(4);
            when "101"  => an_L <= x"DF"; s_led_bcd <= en_L(6) & hex2; dp_L <= en_dp_L(5);
            when "110"  => an_L <= x"BF"; s_led_bcd <= en_L(7) & hex1; dp_L <= en_dp_L(6);
            when "111"  => an_L <= x"7F"; s_led_bcd <= en_L(0) & hex0; dp_L <= en_dp_L(7);
            when others => an_L <= x"FF";
        end case;
    end process;
    
    process(s_led_bcd)
    begin
        case s_led_bcd is
            when "00000" => seg_L <= "1000000";   -- "0"
            when "00001" => seg_L <= "1111001";   -- "1"
            when "00010" => seg_L <= "0100100";   -- "2"
            when "00011" => seg_L <= "0110000";   -- "3"
                    
            when "00100" => seg_L <= "0011001";   -- "4"
            when "00101" => seg_L <= "0010010";   -- "5"
            when "00110" => seg_L <= "0000010";   -- "6"
            when "00111" => seg_L <= "1111000";   -- "7"
                    
            when "01000" => seg_L <= "0000000";   -- "8"
            when "01001" => seg_L <= "0010000";   -- "9"
            when "01010" => seg_L <= "0001000";   -- "A"
            when "01011" => seg_L <= "0000011";   -- "B"
                    
            when "01100" => seg_L <= "1000110";   -- "C"
            when "01101" => seg_L <= "0100001";   -- "D"
            when "01110" => seg_L <= "0000110";   -- "E"
            when "01111" => seg_L <= "0001110";   -- "F"
            when others  => seg_L <= "1111111";   -- "OFF"
        end case;
    end process;         
        
end Behavioral;
