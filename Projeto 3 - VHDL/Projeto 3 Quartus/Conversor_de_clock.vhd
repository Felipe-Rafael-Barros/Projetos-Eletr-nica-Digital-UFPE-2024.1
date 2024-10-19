library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Conversor_de_clock is
   generic (
      Contagem : integer := 10000000;  -- módulo de contagem de clocks
      n : integer := 32            -- Número de bits do contador 
   );
   port (
      clk_in : in std_logic;              
      reset : in std_logic := '0';        
      clk_out : out std_logic             
   );
end Conversor_de_clock;

architecture Behavioral of Conversor_de_clock is
   -- Contador dinâmico de acordo com o número de bits definido
   signal counter : unsigned(n-1 downto 0) := (others => '0');
   signal clk_out_reg : std_logic := '0';  -- Registrador do clock de saída
begin

   -- Processo síncrono controlado pela borda de subida do clock de entrada
   process(clk_in, reset)
   begin
      if reset = '1' then
         counter <= (others => '0');      -- Reset do contador
         clk_out_reg <= '0';              -- Reset do clock de saída
      elsif rising_edge(clk_in) then
         if counter = (Contagem - 1) then
            counter <= (others => '0');   -- Reinicia o contador
            clk_out_reg <= not clk_out_reg;  -- Inverte o clock de saída

         else
            counter <= counter + 1;       -- Incrementa o contador
         end if;
      end if;
   end process;
   -- Atribui o valor do registrador à saída do clock
   clk_out <= clk_out_reg;

end Behavioral;
