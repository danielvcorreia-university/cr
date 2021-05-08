library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter_16b is
    Port ( clk     : in STD_LOGIC;
           enable  : in STD_LOGIC;
           reset   : in STD_LOGIC;
           clk2Hz  : in STD_LOGIC;
           btn_inc : in STD_LOGIC;
           btn_dec : in STD_LOGIC;
           state   : in STD_LOGIC_VECTOR(2 downto 0);
           led_out : out STD_LOGIC;
           digit0  : out STD_LOGIC_VECTOR (3 downto 0);
           digit1  : out STD_LOGIC_VECTOR (3 downto 0);
           digit2  : out STD_LOGIC_VECTOR (3 downto 0);
           digit3  : out STD_LOGIC_VECTOR (3 downto 0));
end Counter_16b;

architecture Behavioral of Counter_16b is
    signal s_sec_ls, s_min_ls : unsigned(3 downto 0) := "1001";
    signal s_sec_ms, s_min_ms : unsigned(3 downto 0) := "0101";
    signal s_led_out : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            
            if (state = "010") then
                if(clk2Hz = '1') then
                    if(btn_inc = '1') then
                        if(s_min_ms = "0101") then
                            s_min_ms <= "0000";
                        else
                            s_min_ms <= s_min_ms + 1;
                        end if;
                    elsif (btn_dec = '1') then
                        if(s_min_ms = "0000") then
                            s_min_ms <= "0101";
                        else
                            s_min_ms <= s_min_ms - 1;
                        end if;
                    end if;
                end if;
            elsif (state = "011") then
                if(clk2Hz = '1') then
                    if(btn_inc = '1') then
                        if(s_min_ls = "1001") then
                            s_min_ls <= "0000";
                        else
                            s_min_ls <= s_min_ls + 1;
                        end if;
                    elsif (btn_dec = '1') then
                        if(s_min_ls = "0000") then
                            s_min_ls <= "1001";
                        else
                            s_min_ls <= s_min_ls - 1;
                        end if;                        
                    end if;
                end if;
           elsif (state = "100") then
                if(clk2Hz = '1') then
                    if(btn_inc = '1') then
                        if(s_sec_ms = "0101") then
                            s_sec_ms <= "0000";
                        else
                            s_sec_ms <= s_sec_ms + 1;
                        end if;
                    elsif (btn_dec = '1') then
                        if(s_sec_ms = "0000") then
                            s_sec_ms <= "0101";
                        else
                            s_sec_ms <= s_sec_ms - 1;
                        end if;
                    end if;
                end if;
           elsif (state = "101") then
                if(clk2Hz = '1') then
                    if(btn_inc = '1') then
                        if(s_sec_ls = "1001") then
                            s_sec_ls <= "0000";
                        else
                            s_sec_ls <= s_sec_ls + 1;
                        end if;
                    elsif (btn_dec = '1') then
                        if(s_sec_ls = "0000") then
                            s_sec_ls <= "1001";
                        else
                            s_sec_ls <= s_sec_ls - 1;
                        end if;
                    end if;
                end if;
            end if;         
            if (enable = '1') then
                if (s_sec_ls = "0000") then
                    s_sec_ls <= "1001";
                    if (s_sec_ms = "0000") then
                        s_sec_ms <= "0101";
                        if (s_min_ls = "0000") then
                            s_min_ls <= "1001";
                            if (s_min_ms = "0000") then
                                s_sec_ms <= "0000";
                                s_sec_ls <= "0000";
                                s_min_ls <= "0000";
                                --s_led_out <= '1';
                            else
                                s_min_ms <= s_min_ms - 1;
                            end if;
                        else
                            s_min_ls <= s_min_ls - 1;
                        end if;
                    else
                        s_sec_ms <= s_sec_ms - 1;
                    end if;
                else
                    s_sec_ls <= s_sec_ls - 1;
                end if;
            end if;
            if (s_min_ls = "0000" and s_min_ms = "0000" and s_sec_ls = "0000" and s_sec_ms = "0000") then
                s_led_out <= '1';
            else 
                s_led_out <= '0';
            end if;
        end if;
    end process;
    
    digit0  <= std_logic_vector(s_sec_ls);
    digit1  <= std_logic_vector(s_sec_ms);
    digit2  <= std_logic_vector(s_min_ls);
    digit3  <= std_logic_vector(s_min_ms);
    led_out <= s_led_out;

end Behavioral;
