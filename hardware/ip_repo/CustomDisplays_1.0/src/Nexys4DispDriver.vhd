library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nexys4DispDriver is
    Port ( clk         : in STD_LOGIC;
           en_L        : in STD_LOGIC_VECTOR(7 downto 0);  
           en_dp_L     : in STD_LOGIC_VECTOR(7 downto 0);
           refreshRate : in STD_LOGIC_VECTOR(2 downto 0);
           brightness  : in STD_LOGIC_VECTOR(2 downto 0);
           hex0        : in STD_LOGIC_VECTOR(3 downto 0);
           hex1        : in STD_LOGIC_VECTOR(3 downto 0);
           hex2        : in STD_LOGIC_VECTOR(3 downto 0);
           hex3        : in STD_LOGIC_VECTOR(3 downto 0);
           hex4        : in STD_LOGIC_VECTOR(3 downto 0);
           hex5        : in STD_LOGIC_VECTOR(3 downto 0);
           hex6        : in STD_LOGIC_VECTOR(3 downto 0);
           hex7        : in STD_LOGIC_VECTOR(3 downto 0);
           an_L        : out STD_LOGIC_VECTOR(7 downto 0);
           seg_L       : out STD_LOGIC_VECTOR(6 downto 0);
           dp_L        : out STD_LOGIC);
end Nexys4DispDriver;

architecture Behavioral of Nexys4DispDriver is
    signal s_led_bcd : STD_LOGIC_VECTOR(4 downto 0);
    signal s_count : unsigned(2 downto 0);   
    signal s_seg_activate_count : STD_LOGIC_VECTOR(2 downto 0);
    signal s_brightness : STD_LOGIC_VECTOR(7 downto 0);
    signal s_enable_count : natural range 0 to 1_999_999;
    
    type LUTable is array (0 to 7, 0 to 7) of integer range 0 to 2_000_000;
    constant BRIGHTNESS_LUT : LUTable :=
    (   (0, 0, 0, 0, 0, 0, 0, 0),
        (280_000, 140_000, 70_000, 35_000, 17_500, 8_750, 4_375, 2_187),
        (580_000, 290_000, 145_000, 72_500, 36_250, 18_125, 9_063, 4_531),
        (860_000, 430_000, 215_000, 107_500, 53_750, 26_875, 13_437, 6_719),
        (1_140_000, 570_000, 285_000, 142_500, 71_250, 35_625, 17_812, 8_906),
        (1_420_000, 710_000, 355_000, 177_500, 88_750, 44_375, 22_187, 11_094),
        (1_720_000, 860_000, 430_000, 215_000, 107_500, 53_750, 26_875, 13_437),
        (2_000_000, 1_000_000, 500_000, 250_000, 125_000, 62_500, 31_250, 15_625));
        
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (s_enable_count >= BRIGHTNESS_LUT( 7, to_integer(unsigned(refreshRate))) - 1 ) then
                s_count <= s_count + 1;
                s_enable_count <= 0;
                s_brightness <= (others => '0');
            else
                s_enable_count <= s_enable_count + 1;
                if (s_enable_count >= BRIGHTNESS_LUT( to_integer(unsigned(brightness)),
                                                      to_integer(unsigned(refreshRate))) ) then
                    s_brightness <= (others => '1');
                end if;
            end if;            
        end if;
    end process;
    
    s_seg_activate_count <= std_logic_vector(s_count);
    
    process(s_seg_activate_count, en_dp_L, en_L)    
    begin
        case s_seg_activate_count is
            when "000"  => an_L <= x"FE" or s_brightness; s_led_bcd <= en_L(0) & hex0; dp_L <= en_dp_L(0);
            when "001"  => an_L <= x"FD" or s_brightness; s_led_bcd <= en_L(1) & hex1; dp_L <= en_dp_L(1);
            when "010"  => an_L <= x"FB" or s_brightness; s_led_bcd <= en_L(2) & hex2; dp_L <= en_dp_L(2);
            when "011"  => an_L <= x"F7" or s_brightness; s_led_bcd <= en_L(3) & hex3; dp_L <= en_dp_L(3);
            when "100"  => an_L <= x"EF" or s_brightness; s_led_bcd <= en_L(4) & hex4; dp_L <= en_dp_L(4);
            when "101"  => an_L <= x"DF" or s_brightness; s_led_bcd <= en_L(5) & hex5; dp_L <= en_dp_L(5);
            when "110"  => an_L <= x"BF" or s_brightness; s_led_bcd <= en_L(6) & hex6; dp_L <= en_dp_L(6);
            when "111"  => an_L <= x"7F" or s_brightness; s_led_bcd <= en_L(7) & hex7; dp_L <= en_dp_L(7);
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
