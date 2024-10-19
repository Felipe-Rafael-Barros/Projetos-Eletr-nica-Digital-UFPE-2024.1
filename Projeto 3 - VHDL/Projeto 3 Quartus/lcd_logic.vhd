LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE WORK.lcd_vhdl_package.ALL;
ENTITY lcd_logic IS
  PORT( 	clk      : IN  STD_LOGIC;  --clock principal			
			clk_3_seg: IN  STD_LOGIC;  --clock 3 seg
			clk_1_seg: IN  STD_LOGIC;  --clock 1 seg
			lcd_busy : IN  STD_LOGIC;  --feedback do controlador (1)ocupado/(0)disponível	
			botao 	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 1); --botões
			lcd_e 	: OUT STD_LOGIC;  --retem os dados no controlador LCD
			lcd_bar	: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);  --(9) rs (8) rw (7..0) dado char
			contagem_relogio1, contagem_relogio2, contagem_relogio3, contagem_relogio4, contagem_relogio5, contagem_relogio6 : IN std_logic_vector(3 downto 0);
			seletor_display : IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			relogio1,alarme1,alarme2,alarme3 : IN 	STD_LOGIC
		);
END lcd_logic;
ARCHITECTURE bhv OF lcd_logic IS
	--Registradores
	SIGNAL lcd_enable : STD_LOGIC;
	SIGNAL lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
	--Barramento de dados do display
	SIGNAL L1 : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("   ELETRONICA   ");--16 caracteres!!!;
	SIGNAL L2 : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("  Digital UFPE  ");--16 caracteres!!!;
	SIGNAL LR : std_logic_vector (127 DOWNTO 0);--16 caracteres!!!;
	SIGNAL frase_Relogio : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("    RELOGIO     ");--16 caracteres!!!;
	SIGNAL frase_Ajuste_Relogio  : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("AJUSTE RELOGIO C");--16 caracteres!!!;
	SIGNAL frase_Ajuste_Alarme1  : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("AJUSTE ALARME1 C");--16 caracteres!!!;
	SIGNAL frase_Ajuste_Alarme2  : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("AJUSTE ALARME2 C");--16 caracteres!!!;
	SIGNAL frase_Ajuste_Alarme3  : std_logic_vector (127 DOWNTO 0):= to_std_logic_vector("AJUSTE ALARME3 C");--16 caracteres!!!;
	
	
	
	
	--constantes
	SIGNAL frase1_1 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("   ELETRONICA   ");--16 caracteres!!!
	SIGNAL frase1_2 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("  Digital UFPE  ");--16 caracteres!!!
	
	SIGNAL frase2_1 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector(" RELOGIO DIGITAL");--16 caracteres!!!
	SIGNAL frase2_2 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("    PROJETO 3   ");--16 caracteres!!!
	
	SIGNAL frase3_1 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("     ALYSSON    ");--16 caracteres!!!
	SIGNAL frase3_2 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("   CAVALCANTE   ");--16 caracteres!!!
	
	SIGNAL frase4_1 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("     FELIPE     ");--16 caracteres!!!
	SIGNAL frase4_2 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("     BARROS     ");--16 caracteres!!!
	
	SIGNAL frase5_1 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("     MARIA      ");--16 caracteres!!!
	SIGNAL frase5_2 : std_logic_vector (127 DOWNTO 0) := to_std_logic_vector("    VICTORIA    ");--16 caracteres!!!
	

	
	TYPE ESTADOS IS (INICIAL, RELOGIO);
	SIGNAL  estado  : ESTADOS := INICIAL;
	
BEGIN
--atribuição contínua das saídas registradas
 lcd_e <= lcd_enable;
 lcd_bar <= lcd_bus;
 


 PROCESS(clk) -- Mudar as frases do estado inicial
	VARIABLE mudanca  :  INTEGER RANGE 0 TO 4 := 0; 
 BEGIN
	
		IF (rising_edge(clk_3_seg)) AND (estado = INICIAL) THEN
			CASE mudanca IS
				 WHEN 0 => L1 <= frase1_1; L2 <= frase1_2;   
				 WHEN 1 => L1 <= frase2_1; L2 <= frase2_2;
				 WHEN 2 => L1 <= frase3_1; L2 <= frase3_2;
				 WHEN 3 => L1 <= frase4_1; L2 <= frase4_2;
				 WHEN 4 => L1 <= frase5_1; L2 <= frase5_2;
			END CASE;
			IF (mudanca < 4) THEN
				mudanca := mudanca + 1; --incrementa o estado
			ELSE mudanca := 0; --reinicia o estado
		
			END IF;
		END IF;
		
			

	
END PROCESS;
			

 
 
 PROCESS(clk)
	VARIABLE char  :  INTEGER RANGE 0 TO 34 := 0; --6 bits
 BEGIN
  IF rising_edge(clk) THEN
	 IF (botao(1) = '1') THEN
		estado <= RELOGIO;
	 END IF; 
	CASE estado IS 
		WHEN INICIAL => -- 1º ESTADO DA MÁQUINA 			
				IF (lcd_busy = '0' AND lcd_enable = '0') THEN
					lcd_enable <= '1'; --habilita o LCD
					IF (char < 34) THEN
						char := char + 1; --incrementa o estado
					ELSE char := 0; --reinicia o estado
					END IF;
					CASE char IS --verifica o estado atual
						WHEN 0  => lcd_bus <= "00" & "10000000"; --inst. linha 1
						WHEN 1  => lcd_bus <= "10" & L1(127 DOWNTO 120); --prim. char da linha 1
						WHEN 2  => lcd_bus <= "10" & L1(119 DOWNTO 112);
						WHEN 3  => lcd_bus <= "10" & L1(111 DOWNTO 104);
						WHEN 4  => lcd_bus <= "10" & L1(103 DOWNTO 96);
						WHEN 5  => lcd_bus <= "10" & L1(95 DOWNTO 88);
						WHEN 6  => lcd_bus <= "10" & L1(87 DOWNTO 80);
						WHEN 7  => lcd_bus <= "10" & L1(79 DOWNTO 72);
						WHEN 8  => lcd_bus <= "10" & L1(71 DOWNTO 64);
						WHEN 9  => lcd_bus <= "10" & L1(63 DOWNTO 56);
						WHEN 10 => lcd_bus <= "10" & L1(55 DOWNTO 48);
						WHEN 11 => lcd_bus <= "10" & L1(47 DOWNTO 40);
						WHEN 12 => lcd_bus <= "10" & L1(39 DOWNTO 32);
						WHEN 13 => lcd_bus <= "10" & L1(31 DOWNTO 24);
						WHEN 14 => lcd_bus <= "10" & L1(23 DOWNTO 16);
						WHEN 15 => lcd_bus <= "10" & L1(15 DOWNTO 8);
						WHEN 16 => lcd_bus <= "10" & L1(7 DOWNTO 0); --ult char da linha 1
								 
						WHEN 17 => lcd_bus <= "00" & "11000000"; --inst. linha 2
						WHEN 18 => lcd_bus <= "10" & L2(127 DOWNTO 120); --prim. char da linha 2
						WHEN 19 => lcd_bus <= "10" & L2(119 DOWNTO 112);
						WHEN 20 => lcd_bus <= "10" & L2(111 DOWNTO 104);
						WHEN 21 => lcd_bus <= "10" & L2(103 DOWNTO 96);
						WHEN 22 => lcd_bus <= "10" & L2(95 DOWNTO 88);
						WHEN 23 => lcd_bus <= "10" & L2(87 DOWNTO 80);
						WHEN 24 => lcd_bus <= "10" & L2(79 DOWNTO 72);
						WHEN 25 => lcd_bus <= "10" & L2(71 DOWNTO 64);
						WHEN 26 => lcd_bus <= "10" & L2(63 DOWNTO 56);
						WHEN 27 => lcd_bus <= "10" & L2(55 DOWNTO 48);
						WHEN 28 => lcd_bus <= "10" & L2(47 DOWNTO 40);
						WHEN 29 => lcd_bus <= "10" & L2(39 DOWNTO 32);
						WHEN 30 => lcd_bus <= "10" & L2(31 DOWNTO 24);
						WHEN 31 => lcd_bus <= "10" & L2(23 DOWNTO 16);
						WHEN 32 => lcd_bus <= "10" & L2(15 DOWNTO 8);
						WHEN 33 => lcd_bus <= "10" & L2(7 DOWNTO 0);--ult. char da linha 2			 
						WHEN OTHERS => lcd_enable <= '0'; --desabilita o LCD
					END CASE;
					
				ELSE lcd_enable <= '0'; --desabilita o LCD
				END IF;
					
		WHEN RELOGIO =>   -- 2º ESTADO DA MÁQUINA
				IF (lcd_busy = '0' AND lcd_enable = '0') THEN
						lcd_enable <= '1'; --habilita o LCD
						IF (char < 34) THEN
							char := char + 1; --incrementa o estado
						ELSE char := 0; --reinicia o estado
						END IF;
						CASE char IS --verifica o estado atual
							WHEN 0  => lcd_bus <= "00" & "10000000"; --inst. linha 1
							WHEN 1  => lcd_bus <= "10" & "00100000";--prim. char da linha 1
							WHEN 2  => lcd_bus <= "10" & "00100000";
							WHEN 3  => lcd_bus <= "10" & "00100000";
							WHEN 4  => lcd_bus <= "10" & "00100000";
							WHEN 5  => 
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "101") ) or (botao(1) = '0' or (seletor_display /= "101")) then 
												lcd_bus <= "10" & "0011" & contagem_relogio6;  -- Hora mais significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							WHEN 6  => lcd_bus <= "10" & "0011" & contagem_relogio5;  -- Hora menos significativo
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "100") ) or (botao(1) = '0' or (seletor_display /= "100")) then 
												lcd_bus <= "10" & "0011" & contagem_relogio5;  -- Hora menos significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							
							WHEN 7  => lcd_bus <= "10" & "00111010";
							WHEN 8  => 
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "011") ) or (botao(1) = '0' or (seletor_display /= "011")) then 
												lcd_bus <= "10" & "0011" & contagem_relogio4;  -- minuto mais significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							
							WHEN 9  => 
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "010") ) or (botao(1) = '0' or (seletor_display /= "010")) then 
												lcd_bus <= "10" & "0011" & contagem_relogio3;  -- minuto menos significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							WHEN 10 => lcd_bus <= "10" & "00111010";
							WHEN 11 =>
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "001") ) or (botao(1) = '0' or (seletor_display /= "001")) then 
												lcd_bus <= "10" & "0011" & contagem_relogio2;  -- segundo mais significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							
							
							WHEN 12 => 
											if ((clk_1_seg = '1') and (botao(1) = '1') and (seletor_display = "000") ) or (botao(1) = '0' or (seletor_display /= "000") ) then 
												lcd_bus <= "10" & "0011" & contagem_relogio1;  -- Segundo menos significativo
											else
												lcd_bus <= "10" & "00100000";
											end if;
							WHEN 13 => lcd_bus <= "10" & "00100000";
							WHEN 14 => lcd_bus <= "10" & "00100000";
							WHEN 15 => lcd_bus <= "10" & "00100000";
							WHEN 16 => lcd_bus <= "10" & "00100000"; --ult char da linha 1
							
							
							CASE botao(1) IS
							WHEN '1' =>
								IF   relogio1 = '1'  THEN LR <= frase_Ajuste_Relogio;
								ELSIF alarme1 = '1'  THEN LR <= frase_Ajuste_Alarme1;
								ELSIF alarme2 = '1'  THEN LR <= frase_Ajuste_Alarme2;
								ELSIF alarme3 = '1'  THEN LR <= frase_Ajuste_Alarme3;
								END IF;
							WHEN '0' => 
								LR <= frase_Relogio;
							END CASE;
							
							
 
							WHEN 17 => lcd_bus <= "00" & "11000000"; --inst. linha 2
							WHEN 18 => lcd_bus <= "10" & LR(127 DOWNTO 120); --prim. char da linha 2
							WHEN 19 => lcd_bus <= "10" & LR(119 DOWNTO 112);
							WHEN 20 => lcd_bus <= "10" & LR(111 DOWNTO 104);
							WHEN 21 => lcd_bus <= "10" & LR(103 DOWNTO 96);
							WHEN 22 => lcd_bus <= "10" & LR(95 DOWNTO 88);
							WHEN 23 => lcd_bus <= "10" & LR(87 DOWNTO 80);
							WHEN 24 => lcd_bus <= "10" & LR(79 DOWNTO 72);
							WHEN 25 => lcd_bus <= "10" & LR(71 DOWNTO 64);
							WHEN 26 => lcd_bus <= "10" & LR(63 DOWNTO 56);
							WHEN 27 => lcd_bus <= "10" & LR(55 DOWNTO 48);
							WHEN 28 => lcd_bus <= "10" & LR(47 DOWNTO 40);
							WHEN 29 => lcd_bus <= "10" & LR(39 DOWNTO 32);
							WHEN 30 => lcd_bus <= "10" & LR(31 DOWNTO 24);
							WHEN 31 => lcd_bus <= "10" & LR(23 DOWNTO 16);
							WHEN 32 => lcd_bus <= "10" & LR(15 DOWNTO 8);
							WHEN 33 => lcd_bus <= "10" & LR(7 DOWNTO 0);--ult. char da linha 2			 
							WHEN OTHERS => lcd_enable <= '0'; --desabilita o LCD
						END CASE;
					ELSE
						lcd_enable <= '0'; --desabilita o LCD
					END IF;
		
	END CASE;
  END IF;
 END PROCESS;
END ARCHITECTURE;
