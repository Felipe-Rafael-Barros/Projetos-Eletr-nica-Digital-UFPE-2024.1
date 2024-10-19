module lcd_logic
(
	input wire clk, lcd_busy, iniciar_relogio,clock_piscar, // clock50MHZ, VERIFICA SE LCD DISPONÍVEL, BOTÃO PARA INICIAR RELOGIO, CLOCK_2SEG
	input centena,       
	input [3:0]dezena,   
	input [3:0]unidade, 
	input [3:0]decimo, 
	input [23:0]hora,  //vetor de horas e alarmes
	input relogio_ativo,
	input alarme1_ativo,
	input alarme2_ativo,
	input alarme3_ativo,
	input ajuste,
	input [2:0] seletor_dig,
	output lcd_ena,
	output [9:0] lcd_bar,
	output ativamento
);

reg [1:0] estado = 2'b00;
reg [1:0] seletor = 2'b00;	
reg aux = 1'b1;
reg lcd_enable;
reg [9:0] lcd_bus;

assign lcd_ena = lcd_enable;
assign lcd_bar = lcd_bus;
assign ativamento = aux;


always @(posedge iniciar_relogio) begin
	
	case (seletor)
		0: seletor <= 2'b01;
		1: seletor <= 2'b10;
		2: seletor <= 2'b11;
		3: seletor <= 2'b11;
	endcase
	
end

always @(posedge clk) 
begin

	reg [5:0] char = 6'd0; //em caso de erro, usar o assign.
	
	
	if(seletor == 2'b00) begin //Seleciona qual frase estará mostrando no lcd referente a determinada musica.
		estado <= 2'b00;
	end
	else if(seletor == 2'b01) begin
		estado <= 2'b01;
	end
	else if(seletor == 2'b10) begin
		estado <= 2'b10;
	end
	else if(seletor == 2'b11) begin
		estado <= 2'b11;
		aux <= 1'b0;
	end
	
	case(estado)
		2'b00: begin
			if((!lcd_busy) & (!lcd_enable)) begin
				lcd_enable <= 1'b1; //Habilita o LCD
				if(char < 34) begin 
					char = char + 1;//Incrementa o estado
				end
				else begin
					char = 0;
				end
				case (char)
					0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
					1  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					2  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					3  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					4  : lcd_bus <= {2'b10, 8'b01000101}; //E  
					5  : lcd_bus <= {2'b10, 8'b01101100}; //l 
					6  : lcd_bus <= {2'b10, 8'b01100101}; //e   
					7  : lcd_bus <= {2'b10, 8'b01110100}; //t 
					8  : lcd_bus <= {2'b10, 8'b01110010}; //r   
					9  : lcd_bus <= {2'b10, 8'b01101111}; //o   
					10 : lcd_bus <= {2'b10, 8'b01101110}; //n   
					11 : lcd_bus <= {2'b10, 8'b01101001}; //i  
					12 : lcd_bus <= {2'b10, 8'b01100011}; //c
					13 : lcd_bus <= {2'b10, 8'b01100001}; //a  
					14 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					15 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço    
					16 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
					18 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					19 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					20 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					21 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					22 : lcd_bus <= {2'b10, 8'b01000100}; //D
					23 : lcd_bus <= {2'b10, 8'b01101001}; //i
					24 : lcd_bus <= {2'b10, 8'b01100111}; //g  
					25 : lcd_bus <= {2'b10, 8'b01101001}; //i   
					26 : lcd_bus <= {2'b10, 8'b01110100}; //t 
					27 : lcd_bus <= {2'b10, 8'b01100001}; //a 
					28 : lcd_bus <= {2'b10, 8'b01101100}; //l   
					29 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					30 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					31 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					32 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					33 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					default: lcd_enable <= 1'b0; //desabilita o LCD
				endcase
			end
			else 
			begin
				lcd_enable <= 1'b0; //desabilita o LCD
			end
		end //end do estado 1 estado
		
		2'b01: begin			
			if((!lcd_busy) & (!lcd_enable)) begin
				lcd_enable <= 1'b1; //Habilita o LCD
				if(char < 34) begin 
					char = char + 1;//Incrementa o estado
				end
				else begin
					char = 0;
				end
				case (char)
					0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
					1  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					2  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					3  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					4  : lcd_bus <= {2'b10, 8'b01010000}; //P
					5  : lcd_bus <= {2'b10, 8'b01110010}; //r 
					6  : lcd_bus <= {2'b10, 8'b01101111}; //o   
					7  : lcd_bus <= {2'b10, 8'b01101010}; //j 
					8  : lcd_bus <= {2'b10, 8'b01100101}; //e   
					9  : lcd_bus <= {2'b10, 8'b01110100}; //t   
					10 : lcd_bus <= {2'b10, 8'b01101111}; //o
					11 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					12 : lcd_bus <= {2'b10, 8'b00110100}; //4
					13 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço  
					14 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					15 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço    
					16 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					
					17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
					18 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					19 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					20 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					21 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					22 : lcd_bus <= {2'b10, 8'b01010110}; //V
					23 : lcd_bus <= {2'b10, 8'b01100101}; //e
					24 : lcd_bus <= {2'b10, 8'b01110010}; //r  
					25 : lcd_bus <= {2'b10, 8'b01101001}; //i   
					26 : lcd_bus <= {2'b10, 8'b01101100}; //l 
					27 : lcd_bus <= {2'b10, 8'b01101111}; //o 
					28 : lcd_bus <= {2'b10, 8'b01100111}; //g   
					29 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					30 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
					31 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					32 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					33 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
					default: lcd_enable <= 1'b0; //desabilita o LCD
				endcase
			end
			else 
			begin
				lcd_enable <= 1'b0; //desabilita o LCD
			end
		end //end do estado 2 estado
		
		2'b10: begin					
			if((!lcd_busy) & (!lcd_enable)) begin
				lcd_enable <= 1'b1; //Habilita o LCD
				if(char < 34) begin 
					char = char + 1;//Incrementa o estado
				end
				else begin
					char = 0;
				end
				case (char)
					0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
					1  : lcd_bus <= {2'b10, 8'b01000001}; //A 
					2  : lcd_bus <= {2'b10, 8'b01101100}; //l 
					3  : lcd_bus <= {2'b10, 8'b01110101}; //u
					4  : lcd_bus <= {2'b10, 8'b01101110}; //n 
					5  : lcd_bus <= {2'b10, 8'b01101111}; //o 
					6  : lcd_bus <= {2'b10, 8'b01110011}; //s   
					7  : lcd_bus <= {2'b10, 8'b00111010}; //:  
					8  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					9  : lcd_bus <= {2'b10, 8'b01000001}; //A
					10 : lcd_bus <= {2'b10, 8'b01101100}; //l   
					11 : lcd_bus <= {2'b10, 8'b01111001}; //y   
					12 : lcd_bus <= {2'b10, 8'b01110011}; //s  
					13 : lcd_bus <= {2'b10, 8'b01110011}; //s   
					14 : lcd_bus <= {2'b10, 8'b01101111}; //o  
					15 : lcd_bus <= {2'b10, 8'b01101110}; //n  
					16 : lcd_bus <= {2'b10, 8'b00101100}; //,
					
					17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
					18 : lcd_bus <= {2'b10, 8'b01000110}; //F
					19 : lcd_bus <= {2'b10, 8'b01100101}; //e
					20 : lcd_bus <= {2'b10, 8'b01101100}; //l 
					21 : lcd_bus <= {2'b10, 8'b01101001}; //i   
					22 : lcd_bus <= {2'b10, 8'b01110000}; //p
					23 : lcd_bus <= {2'b10, 8'b01100101}; //e  
					24 : lcd_bus <= {2'b10, 8'b00101100}; //,  
					25 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço   
					26 : lcd_bus <= {2'b10, 8'b01010110}; //V
					27 : lcd_bus <= {2'b10, 8'b01101001}; //i 
					28 : lcd_bus <= {2'b10, 8'b01100011}; //c   
					29 : lcd_bus <= {2'b10, 8'b01110100}; //t   
					30 : lcd_bus <= {2'b10, 8'b01101111}; //o
					31 : lcd_bus <= {2'b10, 8'b01110010}; //r   
					32 : lcd_bus <= {2'b10, 8'b01101001}; //i
					33 : lcd_bus <= {2'b10, 8'b01100001}; //a   			 
					default : lcd_enable <= 1'b0; //desabilita o LCD
				endcase
			end
			else begin
				lcd_enable <= 1'b0; //desabilita o LCD
			end
		end //end do estado 3 estado
		
		
		2'b11: begin
			if((!lcd_busy) & (!lcd_enable)) begin
				lcd_enable <= 1'b1; //Habilita o LCD
				if(char < 34) begin 
					char = char + 1;//Incrementa o estado
				end
				else begin
					char = 0;
				end
				if (ajuste==0 & relogio_ativo==1) begin		// frase relógio
					case (char)
						0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
						1  : lcd_bus <= {2'b10, 8'b01010010}; //R
						2  : lcd_bus <= {2'b10, 8'b01100101}; //e
						3  : lcd_bus <= {2'b10, 8'b01101100}; //l
						4  : lcd_bus <= {2'b10, 8'b01101111}; //o 
						5  : lcd_bus <= {2'b10, 8'b01100111}; //g
						6  : lcd_bus <= {2'b10, 8'b01101001}; //i  
						7  : lcd_bus <= {2'b10, 8'b01101111}; //o
						8  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						9  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						10 : lcd_bus <= {2'b10, 8'b01010100}; //T 
						11 : lcd_bus <= {2'b10, 8'b01100101}; //e 
						12 : lcd_bus <= {2'b10, 8'b01101101}; //m
						13 : lcd_bus <= {2'b10, 8'b01110000}; //p
						14 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
						15 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						16 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						
						17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
						18 : 																			//H
							begin 
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd5)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[23:20]}; 	
								end
							end
						19 : 
							begin 																	//H
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd4)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[19:16]}; 	
								end
							end 	
						20 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//: 
						21 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd3)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[15:12]}; 	
								end
							end 	   
						22 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd2)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[11:8]}; 	
								end
							end              	
						23 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//:  
						24 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd1)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[7:4]}; 	
								end
							end              	//S  
						25 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd0)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[3:0]}; 	
								end
							end                 	   
						26 : lcd_bus <= {2'b10, 8'b00100000};     	  	//Espaço 
						27 : lcd_bus <= {2'b10, 7'b0011000, centena};  	//Centena 
						28 : lcd_bus <= {2'b10, 4'b0011, dezena[3:0]}; 	//Dezena
						29 : lcd_bus <= {2'b10, 4'b0011, unidade[3:0]};	//Unidade   
						30 : lcd_bus <= {2'b10, 8'b00101110}; 				//.
						31 : lcd_bus <= {2'b10, 4'b0011, decimo[3:0]};  //Decimo
						32 : lcd_bus <= {2'b10, 8'b11011111}; 				//º
						33 : lcd_bus <= {2'b10, 8'b01000011}; 				//C
					endcase
				end
				else if (ajuste==1 & relogio_ativo==1) begin		// frase ajuste alarme 1
					case (char)
						0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
						1  : lcd_bus <= {2'b10, 8'b01000001}; //A
						2  : lcd_bus <= {2'b10, 8'b01101010}; //j
						3  : lcd_bus <= {2'b10, 8'b01110101}; //u
						4  : lcd_bus <= {2'b10, 8'b01110011}; //s 
						5  : lcd_bus <= {2'b10, 8'b01110100}; //t
						6  : lcd_bus <= {2'b10, 8'b01100101}; //e  
						7  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						8  : lcd_bus <= {2'b10, 8'b01010010}; //R
						9  : lcd_bus <= {2'b10, 8'b01100101}; //e
						10 : lcd_bus <= {2'b10, 8'b01101100}; //l 
						11 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						12 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						13 : lcd_bus <= {2'b10, 8'b01010100}; //T
						14 : lcd_bus <= {2'b10, 8'b01100101}; //e 
						15 : lcd_bus <= {2'b10, 8'b01101101}; //m
						16 : lcd_bus <= {2'b10, 8'b01110000}; //p
						
						17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
						18 : 																			//H
							begin 
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd5)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[23:20]}; 	
								end
							end
						19 : 
							begin 																	//H
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd4)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[19:16]}; 	
								end
							end 	
						20 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//: 
						21 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd3)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[15:12]}; 	
								end
							end 	   
						22 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd2)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[11:8]}; 	
								end
							end              	
						23 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//:  
						24 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd1)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[7:4]}; 	
								end
							end              	//S  
						25 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd0)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[3:0]}; 	
								end
							end                 	   
						26 : lcd_bus <= {2'b10, 8'b00100000};     	  	//Espaço 
						27 : lcd_bus <= {2'b10, 7'b0011000, centena};  	//Centena 
						28 : lcd_bus <= {2'b10, 4'b0011, dezena[3:0]}; 	//Dezena
						29 : lcd_bus <= {2'b10, 4'b0011, unidade[3:0]};	//Unidade   
						30 : lcd_bus <= {2'b10, 8'b00101110}; 				//.
						31 : lcd_bus <= {2'b10, 4'b0011, decimo[3:0]};  //Decimo
						32 : lcd_bus <= {2'b10, 8'b11011111}; 				//º
						33 : lcd_bus <= {2'b10, 8'b01000011}; 				//C
					endcase
				end
				else if (alarme1_ativo) begin		// frase ajuste alarme 1
					case (char)
						0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
						1  : lcd_bus <= {2'b10, 8'b01000001}; //A
						2  : lcd_bus <= {2'b10, 8'b01101010}; //j
						3  : lcd_bus <= {2'b10, 8'b01110101}; //u
						4  : lcd_bus <= {2'b10, 8'b01110011}; //s 
						5  : lcd_bus <= {2'b10, 8'b01110100}; //t
						6  : lcd_bus <= {2'b10, 8'b01100101}; //e  
						7  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						8  : lcd_bus <= {2'b10, 8'b01000001}; //A
						9  : lcd_bus <= {2'b10, 8'b00110001}; //1
						10 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
						11 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						12 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						13 : lcd_bus <= {2'b10, 8'b01010100}; //T
						14 : lcd_bus <= {2'b10, 8'b01100101}; //e 
						15 : lcd_bus <= {2'b10, 8'b01101101}; //m
						16 : lcd_bus <= {2'b10, 8'b01110000}; //p
						
						17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
						18 : 																			//H
							begin 
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd5)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[23:20]}; 	
								end
							end
						19 : 
							begin 																	//H
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd4)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[19:16]}; 	
								end
							end 	
						20 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//: 
						21 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd3)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[15:12]}; 	
								end
							end 	   
						22 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd2)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[11:8]}; 	
								end
							end              	
						23 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//:  
						24 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd1)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[7:4]}; 	
								end
							end              	//S  
						25 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd0)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[3:0]}; 	
								end
							end                 	   
						26 : lcd_bus <= {2'b10, 8'b00100000};     	  	//Espaço 
						27 : lcd_bus <= {2'b10, 7'b0011000, centena};  	//Centena 
						28 : lcd_bus <= {2'b10, 4'b0011, dezena[3:0]}; 	//Dezena
						29 : lcd_bus <= {2'b10, 4'b0011, unidade[3:0]};	//Unidade   
						30 : lcd_bus <= {2'b10, 8'b00101110}; 				//.
						31 : lcd_bus <= {2'b10, 4'b0011, decimo[3:0]};  //Decimo
						32 : lcd_bus <= {2'b10, 8'b11011111}; 				//º
						33 : lcd_bus <= {2'b10, 8'b01000011}; 				//C
					endcase
				end
				else if (alarme2_ativo) begin		// frase ajuste alarme 2
					case (char)
						0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
						1  : lcd_bus <= {2'b10, 8'b01000001}; //A
						2  : lcd_bus <= {2'b10, 8'b01101010}; //j
						3  : lcd_bus <= {2'b10, 8'b01110101}; //u
						4  : lcd_bus <= {2'b10, 8'b01110011}; //s 
						5  : lcd_bus <= {2'b10, 8'b01110100}; //t
						6  : lcd_bus <= {2'b10, 8'b01100101}; //e  
						7  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						8  : lcd_bus <= {2'b10, 8'b01000001}; //A
						9  : lcd_bus <= {2'b10, 8'b00110010}; //2
						10 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
						11 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						12 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						13 : lcd_bus <= {2'b10, 8'b01010100}; //T
						14 : lcd_bus <= {2'b10, 8'b01100101}; //e 
						15 : lcd_bus <= {2'b10, 8'b01101101}; //m
						16 : lcd_bus <= {2'b10, 8'b01110000}; //p
						
						17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
						18 : 																			//H
							begin 
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd5)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[23:20]}; 	
								end
							end
						19 : 
							begin 																	//H
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd4)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[19:16]}; 	
								end
							end 	
						20 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//: 
						21 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd3)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[15:12]}; 	
								end
							end 	   
						22 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd2)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[11:8]}; 	
								end
							end              	
						23 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//:  
						24 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd1)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[7:4]}; 	
								end
							end              	//S  
						25 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd0)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[3:0]}; 	
								end
							end                 	   
						26 : lcd_bus <= {2'b10, 8'b00100000};     	  	//Espaço 
						27 : lcd_bus <= {2'b10, 7'b0011000, centena};  	//Centena 
						28 : lcd_bus <= {2'b10, 4'b0011, dezena[3:0]}; 	//Dezena
						29 : lcd_bus <= {2'b10, 4'b0011, unidade[3:0]};	//Unidade   
						30 : lcd_bus <= {2'b10, 8'b00101110}; 				//.
						31 : lcd_bus <= {2'b10, 4'b0011, decimo[3:0]};  //Decimo
						32 : lcd_bus <= {2'b10, 8'b11011111}; 				//º
						33 : lcd_bus <= {2'b10, 8'b01000011}; 				//C
					endcase
				end
				else if (alarme3_ativo) begin		// frase ajuste alarme 3
					case (char)
						0  : lcd_bus <= {2'b00, 8'b10000000}; //inst. linha 1
						1  : lcd_bus <= {2'b10, 8'b01000001}; //A
						2  : lcd_bus <= {2'b10, 8'b01101010}; //j
						3  : lcd_bus <= {2'b10, 8'b01110101}; //u
						4  : lcd_bus <= {2'b10, 8'b01110011}; //s 
						5  : lcd_bus <= {2'b10, 8'b01110100}; //t
						6  : lcd_bus <= {2'b10, 8'b01100101}; //e  
						7  : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						8  : lcd_bus <= {2'b10, 8'b01000001}; //A
						9  : lcd_bus <= {2'b10, 8'b00110011}; //3
						10 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço 
						11 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						12 : lcd_bus <= {2'b10, 8'b00100000}; //Espaço
						13 : lcd_bus <= {2'b10, 8'b01010100}; //T
						14 : lcd_bus <= {2'b10, 8'b01100101}; //e 
						15 : lcd_bus <= {2'b10, 8'b01101101}; //m
						16 : lcd_bus <= {2'b10, 8'b01110000}; //p
						
						17 : lcd_bus <= {2'b00, 8'b11000000}; //inst. linha 2
						18 : 																			//H
							begin 
								if ((ajuste) & (clock_piscar) & (seletor_dig == 3'd5)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[23:20]}; 	
								end
							end
						19 : 
							begin 																	//H
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd4)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[19:16]}; 	
								end
							end 	
						20 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//: 
						21 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd3)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[15:12]}; 	
								end
							end 	   
						22 : 
							begin 																	//M
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd2)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[11:8]}; 	
								end
							end              	
						23 : lcd_bus <= {2'b10, 8'b00111010}; 			  	//:  
						24 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd1)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[7:4]}; 	
								end
							end              	//S  
						25 : 
							begin 																	//S
								if ((ajuste) & (clock_piscar) & (seletor_dig== 3'd0)) 
								begin 
									lcd_bus <= {2'b10, 8'b00100000};
								end
								else begin	
									lcd_bus <= {2'b10, 4'b0011, hora[3:0]}; 	
								end
							end                 	   
						26 : lcd_bus <= {2'b10, 8'b00100000};     	  	//Espaço 
						27 : lcd_bus <= {2'b10, 7'b0011000, centena};  	//Centena 
						28 : lcd_bus <= {2'b10, 4'b0011, dezena[3:0]}; 	//Dezena
						29 : lcd_bus <= {2'b10, 4'b0011, unidade[3:0]};	//Unidade   
						30 : lcd_bus <= {2'b10, 8'b00101110}; 				//.
						31 : lcd_bus <= {2'b10, 4'b0011, decimo[3:0]};  //Decimo
						32 : lcd_bus <= {2'b10, 8'b11011111}; 				//º
						33 : lcd_bus <= {2'b10, 8'b01000011}; 				//C
					endcase
				end
			end
			else begin
				lcd_enable <= 1'b0; //desabilita o LCD
			end
		end //end do estado 4
		
	endcase // end case dos estados
end //end do always

endmodule