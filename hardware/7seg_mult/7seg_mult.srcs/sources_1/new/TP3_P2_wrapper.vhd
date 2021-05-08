library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TP3_P2_tl is
    Port ( clk   : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw    : in STD_LOGIC_VECTOR(15 downto 0);
           an    : out STD_LOGIC_VECTOR(7 downto 0);
           seg   : out STD_LOGIC_VECTOR(6 downto 0);
           dp    : out STD_LOGIC);
end TP3_P2_tl;

architecture Structure of TP3_P2_tl is
    signal s_pulse : STD_LOGIC;
    signal s_en_dp : STD_LOGIC_VECTOR(7 downto 0);
    signal s_sw    : STD_LOGIC_VECTOR(15 downto 0);

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
    
    component PulseGenerator
        Port ( clk     : in STD_LOGIC;
               reset   : in STD_LOGIC;
               pulse   : out STD_LOGIC);
    end component;

begin
    
    s_sw <= sw when rising_edge(clk);                                                                                                               
    s_en_dp <= "0000" & s_sw(15 downto 12);
    
    pulse_enable_displays : PulseGenerator PORT MAP ( clk, '0', 
                                                                           s_pulse );                                                                                                   
                                                                                                                   
    display_controller : Nexys4DispDriver PORT MAP ( clk, s_pulse, s_sw(11 downto 4), s_en_dp, s_sw(3 downto 0),
                                                     "0111", "0000", "0100", "0010", "0000", "0010", "0001",
                                                                an, seg, dp );                                                               

end Structure;
