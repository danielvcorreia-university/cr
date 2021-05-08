library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity stateMachine is
    Port ( clk        : in STD_LOGIC;
           adjust     : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           state      : out STD_LOGIC_VECTOR(2 downto 0));
end stateMachine;

architecture Behavioral of stateMachine is
    type TState is (STOP, START, ADJUST_SEC_LS, ADJUST_SEC_MS, ADJUST_MIN_LS, ADJUST_MIN_MS);
    signal pState, nState : TState := STOP;
begin

sync_process : process(clk)
begin

    if (rising_edge(clk)) then
        pState <= nState;
    end if;
    
end process;
    
comb_precess : process(pState, adjust, start_stop)
begin
    
    nState <= pState;       -- preserve the state
        
    case pState is
        when START =>
            if (adjust = '1') then
                nState <= ADJUST_MIN_MS;
            end if;
            if (start_stop = '1') then
                nState <= STOP;
            end if;
        when STOP =>
            if (adjust = '1') then
                nState <= ADJUST_MIN_MS;
            end if;
            if (start_stop = '1') then
                nState <= START;
            end if;
        when ADJUST_MIN_MS =>
            if (adjust = '1') then
                nState <= ADJUST_MIN_LS;
            end if;
        when ADJUST_MIN_LS =>
            if (adjust = '1') then
                nState <= ADJUST_SEC_MS;
            end if;
        when ADJUST_SEC_MS =>
            if (adjust = '1') then
                nState <= ADJUST_SEC_LS;
            end if;
        when ADJUST_SEC_LS =>
            if (adjust = '1') then
                nState <= STOP;
            end if;
        when others =>
            nState <= START;
    end case;      
end process;

with pState select state <=
    "000" when STOP,
    "001" when START,
    "010" when ADJUST_MIN_MS,
    "011" when ADJUST_MIN_LS,
    "100" when ADJUST_SEC_MS,
    "101" when ADJUST_SEC_LS,
    "111" when others;

end Behavioral;
