library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

-- Declaração da entidade
entity seletor_display is  
   port (
      clk,botao3,ajuste : in std_logic; -- Sinal de clock para mudar a saída (00,01,10,11)
      count : out std_logic_vector(2 downto 0)  -- Saída do contador (2 bits)
   );
end seletor_display;

-- Descrição do comportamento do contador
architecture Behavioral of seletor_display is
   signal count_reg : std_logic_vector(2 downto 0);
begin
   -- Processo síncrono controlado pela borda de subida do clock
   process(clk)
   begin
		if rising_edge(clk) then
			if (botao3='1') then    
				if count_reg = "101" then    -- Valor binário de 5, contagem máxima do nosso contador.
					count_reg <= (others => '0');       -- Reinicia o contador
				else
					count_reg <= std_logic_vector(unsigned(count_reg) + 1);  -- Incrementa o contador
				end if;
			end if;
		
			
			if ajuste = '0' then
				count_reg <= (others => '0'); 
			end if;
		end if;
   end process;
   -- Atribui o valor do registrador à saída
   count <= count_reg;

end Behavioral;
