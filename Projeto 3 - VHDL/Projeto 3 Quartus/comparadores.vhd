library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparadores is
   port (
      clk_buzzer1,clk_buzzer2,clk_buzzer3, clk, comparador1,comparador2,comparador3 : in std_logic;          
		buzzer : out std_logic 	
   );
end comparadores;

architecture Behavioral of comparadores is
begin 

	process(clk)
	begin
		if comparador1 = '1' then
			buzzer <= clk_buzzer1;
		elsif comparador2 = '1' then
			buzzer <= clk_buzzer2;
		elsif comparador3 = '1' then
			buzzer <= clk_buzzer3;
		else
			buzzer <= '0';
		end if;
	end process;
	
end Behavioral;