library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PulseGenerator is
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
           enable  : in STD_LOGIC_VECTOR(2 downto 0);
           pulse   : out STD_LOGIC;
           clk_1Hz : out STD_LOGIC);
end PulseGenerator;

architecture Behavioral of PulseGenerator is
    constant MAX : natural := 100_000_000;
    signal s_cnt : natural range 0 to MAX-1;
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            pulse <= '0';
            clk_1Hz <= '0';
            if (reset = '1') then
                s_cnt <= 0;
            elsif (enable = "001") then
                s_cnt <= s_cnt + 1;
                if (s_cnt > ((MAX/2)-1)) then
                    clk_1Hz <= '1';
                end if;
                if (s_cnt = MAX-1) then
                    s_cnt <= 0;
                    pulse <= '1';
                end if;
            else
                clk_1Hz <= '0';
            end if;
        end if;
    end process;

end Behavioral;
