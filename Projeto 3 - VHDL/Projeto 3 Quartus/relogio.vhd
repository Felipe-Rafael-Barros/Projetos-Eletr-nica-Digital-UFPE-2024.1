library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity relogio is
   port (
      clk,ajuste,clk_alteracao,clk_50m, ajuste_relogio : in std_logic;           
		seletor_display : std_logic_vector(2 downto 0);
      saida1, saida2, saida3, saida4,saida5,saida6 : out std_logic_vector(3 downto 0)  	
   );
end relogio;

architecture Behavioral of relogio is

	TYPE ESTADOS IS (INICIAL, RELOGIO1);
	SIGNAL  estado  : ESTADOS := INICIAL;
	
	signal temp_saida1, temp_saida2, temp_saida3, temp_saida4,temp_saida5,temp_saida6 : std_logic_vector(3 downto 0);
	Signal clock1, clock2, clock3, clock4,clock5,clock6, reset1, reset2, reset3, reset4,reset5,reset6 : std_logic;
	component contador_4bits
      port (
         clk : in std_logic;
         reset : in std_logic;
         count : out std_logic_vector(3 downto 0)
      );
   end component;
	
begin

	contador1 : contador_4bits PORT MAP (clk => clock1,reset => reset1, count => temp_saida1); -- segundo menos significativo 
		
	contador2 : contador_4bits PORT MAP (clk => clock2,reset => reset2, count => temp_saida2); -- segundo mais significativo 
		
	contador3 : contador_4bits PORT MAP (clk => clock3,reset => reset3, count => temp_saida3); -- hora menos significativo
		
	contador4 : contador_4bits PORT MAP (clk => clock4,reset => reset4, count => temp_saida4); -- hora mais significativo
	
	contador5 : contador_4bits PORT MAP (clk => clock5,reset => reset5, count => temp_saida5); -- hora menos significativo
	
	contador6 : contador_4bits PORT MAP (clk => clock6,reset => reset6, count => temp_saida6); -- hora mais significativo
	
	process(clk_50m)	
	begin
		IF rising_edge(clk_50m) THEN
			IF (ajuste = '1') THEN
				estado <= RELOGIO1;
			END IF;
			case estado is
				when INICIAL =>
					if temp_saida1 = "0000" then
						clock1 <= clk;
					else clock1 <= '0'; end if;
					
				when RELOGIO1 =>
					if ajuste_relogio = '1' then
						case seletor_display is 
							when "000" => clock1 <= clk_alteracao; clock2 <= '0'; clock3 <= '0'; clock4 <= '0'; clock5<= '0'; clock6 <= '0';
							when "001" => clock2 <= clk_alteracao; clock1 <= '0'; clock3 <= '0'; clock4 <= '0'; clock5<= '0'; clock6 <= '0';
							when "010" => clock3 <= clk_alteracao; clock1 <= '0'; clock2 <= '0'; clock4 <= '0'; clock5<= '0'; clock6 <= '0';
							when "011" => clock4 <= clk_alteracao; clock1 <= '0'; clock2 <= '0'; clock3 <= '0'; clock5<= '0'; clock6 <= '0';
							when "100" => clock5 <= clk_alteracao; clock1 <= '0'; clock2 <= '0'; clock3 <= '0'; clock4<= '0'; clock6 <= '0';
							when "101" => clock6 <= clk_alteracao; clock1 <= '0'; clock2 <= '0'; clock3 <= '0'; clock4<= '0'; clock5 <= '0';
							when others =>
								clock1 <= '0';clock2 <= '0';clock3 <= '0';clock4 <= '0';clock5 <= '0';clock6 <= '0';
						end case;
						
							-- reset segundo menos significativo
						if (temp_saida1 = "1010") then -- reseta no 10
							reset1 <= '1';
						else
							reset1 <= '0';
						end if;
							-- reset segundo mais significativo	
						if (temp_saida2 = "0110") then -- reseta no 6
							reset2 <= '1';
						else
							reset2 <= '0';
						end if;	
						-- reset minuto menos significativo	
						if (temp_saida3 = "1010") then -- reseta no 10
							reset3 <= '1';
						else
							reset3 <= '0';
						end if;
						-- reset minuto mais significativo	
						if (temp_saida4 = "0110") then -- reseta no 6
							reset4 <= '1';
						else
							reset4 <= '0';
						end if;	
						-- reset hora menos significativo 	
						if (temp_saida5 = "1010") or (temp_saida6 = "0010" and temp_saida5 >= "0100" ) then 
							reset5 <= '1';
						else
							reset5 <= '0';
						end if;	
						-- reset hora mais significativo	
						if (temp_saida6 = "0011")  then 
							reset6 <= '1';
						else
								reset6 <= '0';
						end if;
					end if;
					
					if (ajuste = '0') then
						clock1 <= clk;
						clock2 <= reset1;
						clock3 <= reset2;
						clock4 <= reset3;
						clock5 <= reset4;
						clock6 <= reset5;
							-- reset segundo menos significativo	
						if (temp_saida1 = "1010") then -- reseta no 10
							reset1 <= '1';
						else
							reset1 <= '0';
						end if;
							
							-- reset segundo mais significativo	
						if (temp_saida2 = "0110") then -- reseta no 6
							reset2 <= '1';
						else
							reset2 <= '0';
						end if;	
						-- reset minuto menos significativo	
						if (temp_saida3 = "1010") then -- reseta no 10
							reset3 <= '1';
						else
							reset3 <= '0';
						end if;	
						-- reset minuto mais significativo	
						if (temp_saida4 = "0110") then -- reseta no 6
							reset4 <= '1';
						else
							reset4 <= '0';
						end if;	
						-- reset hora menos significativo 	
						if (temp_saida5 = "1010") or (temp_saida6 = "0010" and temp_saida5 >= "0100" ) then 
							reset5 <= '1';
						else
							reset5 <= '0';
						end if;	
						-- reset hora mais significativo	
						if (temp_saida6 = "0011")  then 
							reset6 <= '1';
						else
								reset6 <= '0';
						end if;
					end if;
					saida1 <= temp_saida1;
					saida2 <= temp_saida2;
					saida3 <= temp_saida3;
					saida4 <= temp_saida4;
					saida5 <= temp_saida5;
					saida6 <= temp_saida6;
			end case;
		end if;
	end process;
end;