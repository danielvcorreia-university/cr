----------------------------------------------------------------------------------
-- Company: Universidade de Aveiro
-- Engineer: Daniel Vala Correia
-- 
-- Create Date: 28.03.2021 15:53:24
-- Design Name: 
-- Module Name: Counter_1Hz_tl_4 - Structure
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

entity Counter_1Hz_tl_4 is
    Port ( clk  : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           led  : out STD_LOGIC_VECTOR(3 downto 0);
           an   : out STD_LOGIC_VECTOR(7 downto 0);
           seg  : out STD_LOGIC_VECTOR(6 downto 0));
end Counter_1Hz_tl_4;

architecture Structure of Counter_1Hz_tl_4 is
    signal s_en, s_reset, s_mode, s_incr, s_decr, s_mux, s_id, s_clk_bl : STD_LOGIC;
    signal s_btnR, s_btnU, s_btnD, s_btnC : STD_LOGIC;
    signal s_bl : STD_LOGIC_VECTOR(7 downto 0);
    signal s_count, s_select : STD_LOGIC_VECTOR(3 downto 0);
        
    component mutex2_1
        Port ( a   : in STD_LOGIC;
               b   : in STD_LOGIC;
               sel : in STD_LOGIC_VECTOR(3 downto 0);
               y   : out STD_LOGIC);
    end component;
    
    component pulse_clk_gen_1Hz
		Port ( clk         : in STD_LOGIC;
               reset       : in STD_LOGIC;
               clk_out_1Hz : out STD_LOGIC;
               pulse       : out STD_LOGIC);
	end component; 
	
	component Counter_4b
		Port ( clk    : in STD_LOGIC;
		       reset  : in STD_LOGIC;
      		   enable : in STD_LOGIC;
      		   count  : out STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component Counter_4b_sel_up_down
		Port ( clk       : in STD_LOGIC;
		       reset     : in STD_LOGIC;
      		   enable    : in STD_LOGIC;
      		   increment : in STD_LOGIC;
               decrement : in STD_LOGIC;
               sel       : in STD_LOGIC_VECTOR(3 downto 0);
      		   count     : out STD_LOGIC_VECTOR (3 downto 0));
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
	
	component blink_module
	   Port ( clk   : in STD_LOGIC;
              pulse : in STD_LOGIC; 
              sel   : in STD_LOGIC_VECTOR (3 downto 0);
              xin   : in STD_LOGIC_VECTOR (7 downto 0);
              yout  : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
begin

    -- register asynchronous inputs
process(clk)
begin
    if (rising_edge(clk)) then
        s_btnC <= btnC;
        s_btnR <= btnR;
        s_btnU <= btnU;
        s_btnD <= btnD;
    end if;
end process;

    -- Less significative display on (x"FE")
    hex2seg_converter : Hex2Seg PORT MAP ( s_count, s_bl,
                                                    an, seg);     
                                                                                   
    led <= s_count;
    
    debouncer_btnU : DebounceUnit PORT MAP ( clk, s_btnU, 
                                                    s_incr );
                                                    
    debouncer_btnD : DebounceUnit PORT MAP ( clk, s_btnD, 
                                                    s_decr );
                                                    
    debouncer_btnR : DebounceUnit PORT MAP ( clk, s_btnR, 
                                                    s_mode );
                                                    
    debouncer_btnC : DebounceUnit PORT MAP ( clk, s_btnC, 
                                                    s_reset );

    pulse_clk_generator_1Hz : pulse_clk_gen_1Hz PORT MAP ( clk, s_reset, s_clk_bl,
                                                    s_en);
                                                    
    select_counter : Counter_4b PORT MAP ( clk, '0', s_mode,
                                                    s_select);
                                                   
    s_id <= s_incr or s_decr;
                                                    
    mutex_type_counter : mutex2_1 PORT MAP ( s_en, s_id, s_select,
                                                    s_mux);
                                                    
    counter : Counter_4b_sel_up_down PORT MAP ( clk, s_reset, s_mux, s_incr, s_decr, s_select,
                                                    s_count);
                                                    
    blinking_module : blink_module PORT MAP ( clk, s_clk_bl, s_select, x"FE",
                                                    s_bl);
                                                    
end Structure;
