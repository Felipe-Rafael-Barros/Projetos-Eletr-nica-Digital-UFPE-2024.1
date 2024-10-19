library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity seletor_ajuste is  
   port (
      clk,botao4,ajuste: in std_logic;           
		relogio, alarme1,alarme2,alarme3 :out std_logic
		
   );
end seletor_ajuste;

architecture Behavioral of seletor_ajuste is
   signal count_reg : std_logic_vector(1 downto 0);  
begin
   -- Processo síncrono controlado pela borda de subida do clock
   process(clk)
   begin
		if rising_edge(clk) then
			if botao4 = '1' then   
				if (count_reg = "11") then    -- Valor binário de 3, contagem máxima do nosso contador.
					count_reg <= (others => '0');       -- Reinicia o contador
				else
					count_reg <= std_logic_vector(unsigned(count_reg) + 1);  -- Incrementa o contador
				end if;
			end if;
			
			
			if (ajuste = '0') then
				count_reg <= (others => '0');
			end if;
		end if;
		
		case count_reg is
			when "00" => relogio <= '1'; 
							 alarme1  <='0';
							 alarme2  <='0';
							 alarme3  <='0';
							 
			when "01" => relogio <= '0'; 
							 alarme1  <='1';
							 alarme2  <='0';
							 alarme3  <='0';
							 
			when "10" => relogio <= '0'; 
							 alarme1  <='0';
							 alarme2  <='1';
							 alarme3  <='0';
							 
			when "11" => relogio <= '0'; 
							 alarme1  <='0';
							 alarme2  <='0';
							 alarme3  <='1';
		end case;
	end process;
		

end Behavioral;
