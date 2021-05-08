library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity TP4_P1_wrapper is
    Port ( clk : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnC : in STD_LOGIC;
           led  : out STD_LOGIC_VECTOR(0 downto 0);
           an   : out STD_LOGIC_VECTOR(7 downto 0);
           seg  : out STD_LOGIC_VECTOR(6 downto 0);
           dp   : out STD_LOGIC);
end TP4_P1_wrapper;

architecture Behavioral of TP4_P1_wrapper is
signal s_btnR, s_btnU, s_btnD, s_btnC : STD_LOGIC;
signal s_reset, s_start_stop, s_u, s_d, s_pulse, s_pulse_displays, s_clk_1Hz, s_freq, s_2pulse : STD_LOGIC;
signal s_disp_sec_ls, s_disp_sec_ms, s_disp_min_ls, s_disp_min_ms : STD_LOGIC_VECTOR(3 downto 0);
signal s_point, s_displays : STD_LOGIC_VECTOR(7 downto 0);
signal s_state : STD_LOGIC_VECTOR(2 downto 0);

component DebounceUnit
	Generic ( kHzClkFreq	 : positive := 100_000;
              mSecMinInWidth : positive := 30;
	          inPolarity	 : STD_LOGIC := '1';
              outPolarity    : STD_LOGIC := '1');
	Port ( refClk	 : in STD_LOGIC;
           dirtyIn	 : in STD_LOGIC;
	       pulsedOut : out STD_LOGIC);
end component;

component PulseGenerator
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
           enable  : in STD_LOGIC_VECTOR(2 downto 0);
           pulse   : out STD_LOGIC;
           clk_1Hz : out STD_LOGIC);
end component;

component PulseGenerator_800Hz
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
           pulse   : out STD_LOGIC);
end component;

component generator
    Generic( NUMBER_STEPS : positive := 50_000_000);
    Port ( clk   : in STD_LOGIC;
           reset : in STD_LOGIC;
           pulse : out STD_LOGIC;
           blink : out STD_LOGIC);
end component;

component Counter_16b
    Port ( clk    : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset  : in STD_LOGIC;
           clk2Hz  : in STD_LOGIC;
           btn_inc : in STD_LOGIC;
           btn_dec : in STD_LOGIC;
           state   : in STD_LOGIC_VECTOR(2 downto 0);
           led_out : out STD_LOGIC;
           digit0 : out STD_LOGIC_VECTOR (3 downto 0);
           digit1 : out STD_LOGIC_VECTOR (3 downto 0);
           digit2 : out STD_LOGIC_VECTOR (3 downto 0);
           digit3 : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component stateMachine
    Port ( clk        : in STD_LOGIC;
           adjust     : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           state      : out STD_LOGIC_VECTOR(2 downto 0));
end component;

component Nexys4DispDriver
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
end component;

component BlinkModule
    Port ( clk   : in STD_LOGIC;
           freq  : in STD_LOGIC;
           state : in STD_LOGIC_VECTOR (2 downto 0);
           xin   : in STD_LOGIC_VECTOR (7 downto 0);
           yout  : out STD_LOGIC_VECTOR (7 downto 0));
end component;

begin

-- register asynchronous inputs
process(clk)
    begin
        if (rising_edge(clk)) then
            s_btnR <= btnR;
            s_btnU <= btnU;
            s_btnD <= btnD;
            s_btnC <= btnC;
        end if;
end process;

    s_point <= "111" & s_clk_1Hz & "1111";

    Debouncer_btnR : DebounceUnit PORT MAP ( clk, s_btnR,
                                                                           s_reset);
                                                                
    Debouncer_btnU : DebounceUnit PORT MAP ( clk, s_btnU,
                                                                               s_u);                                           

    Debouncer_btnD : DebounceUnit PORT MAP ( clk, s_btnD,
                                                                               s_d);
                                                                           
    Debouncer_btnC : DebounceUnit PORT MAP ( clk, s_btnC,
                                                                      s_start_stop);                                                                      
                                                                           
    State_machine : stateMachine PORT MAP ( clk, s_reset, s_start_stop,
                                                                           s_state);                                                                       
                                                                 
    Pulse_clk_gen_1Hz : PulseGenerator PORT MAP ( clk, s_reset, s_state,
                                                     s_pulse, s_clk_1Hz);
                                                                          
    Pulse_generator_800Hz : PulseGenerator_800Hz PORT MAP ( clk, s_reset,
                                                                  s_pulse_displays);                                                                                                                                   
                                                                
    Displays_counter : Counter_16b PORT MAP ( clk, s_pulse, s_reset, s_2pulse, s_btnU, s_btnD, s_state, led(0),
                            s_disp_sec_ls, s_disp_sec_ms, s_disp_min_ls, s_disp_min_ms);                                                         
                                                                
    Display_controller : Nexys4DispDriver PORT MAP ( clk, s_pulse_displays, s_displays, s_point, x"0",
                                                     x"0", s_disp_min_ms, s_disp_min_ls, s_disp_sec_ms, s_disp_sec_ls, x"0", x"0",
                                                                       an, seg, dp);
                                                                       
    Generator_clk_2Hz : generator PORT MAP ( clk, s_reset, s_2pulse,
                                                                           s_freq);       
                                                                           
    Blink_7seg : BlinkModule PORT MAP ( clk, s_freq, s_state, x"C3",
                                                                       s_displays);                                                                                                                                   

end Behavioral;
