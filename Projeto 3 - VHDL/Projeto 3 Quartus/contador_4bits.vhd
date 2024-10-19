library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity contador_4bits is
   port (
      clk : in std_logic;             
      reset : in std_logic := '0';   
      count : out std_logic_vector(3 downto 0)  
   );
end contador_4bits;

architecture Behavioral of contador_4bits is
   signal count_reg : std_logic_vector(3 downto 0); 
begin

   -- Processo síncrono controlado pela borda de subida do clock e reset
   process(clk, reset)
   begin
      if reset = '1' then
         count_reg <= (others => '0');  -- Reset do contador
      elsif rising_edge(clk) then
         count_reg <= std_logic_vector(unsigned(count_reg) + 1);  -- Incrementa o contador
      end if;
   end process;

   -- Atribui o valor do registrador à saída
   count <= count_reg;

end Behavioral;
