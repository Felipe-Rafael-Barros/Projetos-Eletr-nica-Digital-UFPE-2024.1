library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity gerenciador_saidas is
   port (
		clock,ajuste,botao3,botao4,clock_1_seg : in std_logic;
      relogio,alarme1,alarme2,alarme3 : in std_logic;  -- Seleciona qual função ajustar
		comparador1, comparador2,comparador3: out std_logic;
      saida1_Relogio,saida1_Alarme1,saida1_Alarme2,saida1_Alarme3: in std_logic_vector(3 downto 0);
		saida2_Relogio,saida2_Alarme1,saida2_Alarme2,saida2_Alarme3: in std_logic_vector(3 downto 0);
		saida3_Relogio,saida3_Alarme1,saida3_Alarme2,saida3_Alarme3: in std_logic_vector(3 downto 0);
		saida4_Relogio,saida4_Alarme1,saida4_Alarme2,saida4_Alarme3: in std_logic_vector(3 downto 0);
		saida5_Relogio,saida5_Alarme1,saida5_Alarme2,saida5_Alarme3: in std_logic_vector(3 downto 0);
		saida6_Relogio,saida6_Alarme1,saida6_Alarme2,saida6_Alarme3: in std_logic_vector(3 downto 0);
		saida1,saida2,saida3,saida4,saida5,saida6: out std_logic_vector (3 downto 0)
   );
end gerenciador_saidas;

architecture Behavioral of gerenciador_saidas is
	TYPE ESTADOS IS (INICIAL, RELOGIO1);
	SIGNAL  estado  : ESTADOS := INICIAL;
begin
	
   -- Processo de multiplexação controlado por 'acender_displays'
   process(clock)
   begin
	  IF rising_edge(clock) THEN
			
			
			case estado is
			when INICIAL =>
				IF (ajuste = '1') THEN
				estado <= RELOGIO1;
				END IF; 
			
			when RELOGIO1 =>
					if relogio = '1' then
						saida1 <= saida1_Relogio; saida2 <= saida2_Relogio; saida3 <= saida3_Relogio; saida4 <= saida4_Relogio; saida5 <= saida5_Relogio; saida6 <= saida6_Relogio;
					
					elsif alarme1 = '1' then
						
						saida1 <= saida1_alarme1; saida2 <= saida2_alarme1; saida3 <= saida3_alarme1; saida4 <= saida4_alarme1; saida5 <= saida5_alarme1; saida6 <= saida6_alarme1;

					
					elsif alarme2 = '1' then
						saida1 <= saida1_alarme2; saida2 <= saida2_alarme2; saida3 <= saida3_alarme2; saida4 <= saida4_alarme2; saida5 <= saida5_alarme2; saida6 <= saida6_alarme2;

					
					elsif alarme3 = '1' then
						saida1 <= saida1_alarme3; saida2 <= saida2_alarme3; saida3 <= saida3_alarme3; saida4 <= saida4_alarme3; saida5 <= saida5_alarme3; saida6 <= saida6_alarme3;
					end if;
				
			
			       -- Processo principal ou dentro da arquitetura, dependendo de onde o comparador é definido

					if ajuste = '0' then  -- Verifica se não está em modo de ajuste
						-- Verifica se Relógio coincide com o Alarme 1, 2 ou 3
						if (((saida1_Relogio = saida1_alarme1) and 
							 (saida2_Relogio = saida2_alarme1) and 
							 (saida3_Relogio = saida3_alarme1) and 
							 (saida4_Relogio = saida4_alarme1)and 
							 (saida5_Relogio = saida5_alarme1) and 
							 (saida6_Relogio = saida6_alarme1)) and (clock_1_seg = '0')) then
							 
								comparador1 <= '1';  -- Se houver coincidência com algum alarme
								comparador2 <= '0';
								comparador3 <= '0';
								
						elsif botao3 = '1' and botao4 = '1' then
							comparador1 <= '0';  -- Se não houver coincidência
						end if;
						
						if	(((saida1_Relogio = saida1_alarme2) and 
							 (saida2_Relogio = saida2_alarme2) and 
							 (saida3_Relogio = saida3_alarme2) and 
							 (saida4_Relogio = saida4_alarme2)and 
							 (saida5_Relogio = saida5_alarme2) and 
							 (saida6_Relogio = saida6_alarme2)) and (clock_1_seg = '0')) then
							 
								comparador1 <= '0';  -- Se houver coincidência com algum alarme
								comparador2 <= '1';
								comparador3 <= '0';
								
						elsif botao3 = '1' and botao4 = '1' then
							comparador2 <= '0';  -- Se não houver coincidência
						end if; 
						
						if	(((saida1_Relogio = saida1_alarme3) and 
							 (saida2_Relogio = saida2_alarme3) and 
							 (saida3_Relogio = saida3_alarme3) and 
							 (saida4_Relogio = saida4_alarme3)and 
							 (saida5_Relogio = saida5_alarme3) and 
							 (saida6_Relogio = saida6_alarme3)) and (clock_1_seg = '0')) then
							 
								comparador1 <= '0';
								comparador2 <= '0';
								comparador3 <= '1';  -- Se houver coincidência com algum alarme
							 
							
						
						elsif botao3 = '1' and botao4 = '1' then
							comparador3 <= '0';  -- Se não houver coincidência
						end if;
					else
						comparador1 <= '0';  -- Se estiver em modo de ajuste
						comparador2 <= '0';  -- Se estiver em modo de ajuste
						comparador3 <= '0';  -- Se estiver em modo de ajuste
					end if;
			end case;
		end if;
	end process;

end Behavioral;