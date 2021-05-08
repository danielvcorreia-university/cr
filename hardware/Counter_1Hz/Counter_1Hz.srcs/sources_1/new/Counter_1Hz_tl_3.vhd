----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 24.03.2021 09:53:24
-- Design Name: 
-- Module Name: Counter_1Hz_tl_2 - Structural
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

entity Counter_1Hz_tl_3 is
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR(3 downto 0);
           an  : out STD_LOGIC_VECTOR(7 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0));
end Counter_1Hz_tl_3;

architecture Structure of Counter_1Hz_tl_3 is
    signal s_en, s_reset, s_btnU, s_btnD : STD_LOGIC;
    signal s_incr, s_decr : STD_LOGIC;
    signal s_count : STD_LOGIC_VECTOR(3 downto 0);
	
	component Up_Down_Counter_4b
		Port ( clk    : in  STD_LOGIC;
		       reset  : in  STD_LOGIC;
		       enable : in STD_LOGIC;
      		   increment : in STD_LOGIC;
               decrement : in STD_LOGIC;
      		   count : out STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component Hex2Seg
	   Port ( hex   : in STD_LOGIC_VECTOR (3 downto 0);
              en_L  : in STD_LOGIC_VECTOR (7 downto 0);
              an_L  : out STD_LOGIC_VECTOR (7 downto 0);
              seg_L : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component DebounceUnit
        Generic ( kHzClkFreq	 : positive := 100_000;
		          mSecMinInWidth : positive := 50;
	              inPolarity	 : STD_LOGIC := '1';
                  outPolarity    : STD_LOGIC := '1');
        Port ( refClk	 : in STD_LOGIC;
               dirtyIn	 : in STD_LOGIC;
	           pulsedOut : out STD_LOGIC);
	end component;
    
begin

    -- register asynchronous inputs
    process(clk)
    begin
        if (rising_edge(clk)) then
            s_reset <= btnC;
            s_btnU <= btnU;
            s_btnD <= btnD;
        end if;
    end process;

    -- Less significative display on (x"FE")
    hex2seg_converter : Hex2Seg PORT MAP ( s_count, x"FE",
                                                    an, seg);

    led <= s_count;
                                                    
    debouncer_btnU : DebounceUnit PORT MAP ( clk, s_btnU, 
                                                    s_incr );
                                                    
    debouncer_btnD : DebounceUnit PORT MAP ( clk, s_btnD, 
                                                    s_decr );
                                                    
    s_en <= s_incr or s_decr;                                                
                                                    
    counter : Up_Down_Counter_4b PORT MAP ( clk, s_reset, s_en, s_incr, s_decr,
                                                    s_count);
                                                    
end Structure;
