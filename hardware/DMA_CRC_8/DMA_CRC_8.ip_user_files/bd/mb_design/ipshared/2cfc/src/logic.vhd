LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY gateXOr2 IS
  PORT (x0, x1: IN STD_LOGIC;
        y: 		 OUT STD_LOGIC);
END gateXOr2;

ARCHITECTURE logicFunction OF gateXOr2 IS
BEGIN

  y <= x0 XOR x1;
  
END logicFunction;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY gateXOr3 IS
  PORT (x0, x1, x2: IN STD_LOGIC;
        y: 		 	  OUT STD_LOGIC);
END gateXOr3;

ARCHITECTURE logicFunction OF gateXOr3 IS

SIGNAL s_res1: std_logic;

	COMPONENT gateXOr2
		PORT (x0, x1: IN STD_LOGIC;
				y:		  OUT STD_LOGIC);
	END COMPONENT;

BEGIN

	XOr1: gateXOr2 PORT MAP(x0, x1, s_res1);
	XOr2:	gateXOr2 PORT MAP(s_res1, x2, y);
  
END logicFunction;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY gateXOr4 IS
  PORT (x0, x1, x2, x3: IN STD_LOGIC;
        y: 		 	  		OUT STD_LOGIC);
END gateXOr4;

ARCHITECTURE logicFunction OF gateXOr4 IS

SIGNAL s_res1, s_res2: STD_LOGIC;

	COMPONENT gateXOr2
		PORT (x0, x1: IN STD_LOGIC;
				y:		  OUT STD_LOGIC);
	END COMPONENT;

BEGIN

	XOr1: gateXOr2 PORT MAP(x0, x1, s_res1);
	XOr2:	gateXOr2 PORT MAP(x2, x3, s_res2);
	XOr3: gateXOr2 PORT MAP(s_res1, s_res2, y);
  
END logicFunction;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY gateXOr5 IS
  PORT (x0, x1, x2, x3, x4: IN STD_LOGIC;
        y: 		 	  			 OUT STD_LOGIC);
END gateXOr5;

ARCHITECTURE logicFunction OF gateXOr5 IS

SIGNAL s_res1: STD_LOGIC;

	COMPONENT gateXOr2
		PORT (x0, x1: IN STD_LOGIC;
				y:		  OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT gateXOr4
		PORT (x0, x1, x2, x3: IN STD_LOGIC;
				y:		  			 OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN

	XOr1: gateXOr4 PORT MAP(x0, x1, x2, x3, s_res1);
	XOr2:	gateXOr2 PORT MAP(s_res1, x4, y);
  
END logicFunction;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY gateXOr6 IS
  PORT (x0, x1, x2, x3, x4, x5: IN STD_LOGIC;
        y: 		 	  			 	  OUT STD_LOGIC);
END gateXOr6;

ARCHITECTURE logicFunction OF gateXOr6 IS

SIGNAL s_res1, s_res2, s_res3: STD_LOGIC;

	COMPONENT gateXOr2
		PORT (x0, x1: IN STD_LOGIC;
				y:		  OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT gateXOr3
		PORT (x0, x1, x2: IN STD_LOGIC;
				y:		  		OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN

	XOr1:	gateXOr2 PORT MAP(x0, x1, s_res1);
	XOr2:	gateXOr2 PORT MAP(x2, x3, s_res2);
	XOr3:	gateXOr2 PORT MAP(x4, x5, s_res3);
	XOr4:	gateXOr3 PORT MAP(s_res1, s_res2, s_res3, y);
  
END logicFunction;