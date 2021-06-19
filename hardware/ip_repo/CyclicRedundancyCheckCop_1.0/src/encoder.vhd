LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL;

LIBRARY Logic;
USE logic.ALL;

ENTITY encoder IS 
	PORT (data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         data_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)); 
end encoder; 

ARCHITECTURE structure OF encoder IS 

SIGNAL s_a, s_b, s_c, s_d, s_e, s_f, s_g, s_h, s_i, s_j, s_k, s_l : STD_LOGIC;

	COMPONENT gateXOr2
		PORT (x0, x1: IN STD_LOGIC;
				y:		  OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT gateXOr3
		PORT (x0, x1, x2: IN STD_LOGIC;
				y:		  		OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT gateXOr4
		PORT (x0, x1, x2, x3: IN STD_LOGIC;
				y:		  			 OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT gateXOr5
		PORT (x0, x1, x2, x3, x4: IN STD_LOGIC;
				y:		  			 	  OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT gateXOr6
		PORT (x0, x1, x2, x3, x4, x5: IN STD_LOGIC;
				y:		  			 		   OUT STD_LOGIC);
	END COMPONENT;

BEGIN 

-- 16 bit word
data_out(23) <= data_in(15);
data_out(22) <= data_in(14);
data_out(21) <= data_in(13);
data_out(20) <= data_in(12);
data_out(19) <= data_in(11);
data_out(18) <= data_in(10);
data_out(17) <= data_in(9);
data_out(16) <= data_in(8);
data_out(15) <= data_in(7);
data_out(14) <= data_in(6);
data_out(13) <= data_in(5);
data_out(12) <= data_in(4);
data_out(11) <= data_in(3);
data_out(10) <= data_in(2);
data_out(9)  <= data_in(1);
data_out(8)  <= data_in(0);
-- stage 0
a : gateXOr2 PORT MAP (data_in(9), data_in(10),
							 s_a);
b : gateXOr2 PORT MAP (data_in(0), data_in(4),
							 s_b);							
c : gateXOr2 PORT MAP (data_in(1), data_in(3),
							 s_c);							 
d : gateXOr2 PORT MAP (data_in(5), data_in(7),
							 s_d);
e : gateXOr2 PORT MAP (data_in(2), data_in(14),
							 s_e);
f : gateXOr2 PORT MAP (data_in(6), data_in(8),
							 s_f);
g : gateXOr3 PORT MAP (data_in(11), data_in(12), data_in(15),
							 s_g);	
-- stage 1				 
h : gateXOr2 PORT MAP (s_b, data_in(6),
							 s_h);							
i : gateXOr3 PORT MAP (s_b, data_in(2), data_in(9),
							 s_i);						
j : gateXOr3 PORT MAP (s_c, s_d, data_in(13),
							 s_j);							
k : gateXOr3 PORT MAP (s_c, s_e, s_a,
							 s_k);							
l : gateXOr2 PORT MAP (s_f, s_a,
							 s_l);
-- stage 2				 
r7 : gateXOr5 PORT MAP (s_e, s_l, data_in(4), data_in(7), data_in(11),
								data_out(7));								
r6 : gateXOr2 PORT MAP (s_j, s_l,
								data_out(6));								
r5 : gateXOr4 PORT MAP (s_i, s_d, s_f, data_in(12),
								data_out(5));				
r4 : gateXOr2 PORT MAP (s_k, data_in(5),
							   data_out(4));					
r3 : gateXOr4 PORT MAP (s_i, data_in(1), data_in(8), data_in(13),
								data_out(3));							
r2 : gateXOr3 PORT MAP (s_h, s_k, s_g,
								data_out(2));								
r1 : gateXOr3 PORT MAP (s_h, s_j, data_in(15),
								data_out(1));								
r0 : gateXOr6 PORT MAP (data_in(0), data_in(3), s_d, data_in(8), s_a, s_g,
								data_out(0));
							
END structure;
