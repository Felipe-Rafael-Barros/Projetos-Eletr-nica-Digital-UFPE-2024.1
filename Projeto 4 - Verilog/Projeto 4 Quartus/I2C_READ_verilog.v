//Arquivo:   I2C_READ_verilog.v
//Modulo:    I2C_READ_verilog(clock, rst_n, scl,sda, data)
//Descrição: Interface de Comunicação I2C LM75A
//Autor:     Malki-çedheq Benjamim
//Data:      27/01/2022
module I2C_READ_verilog(
	input clk,			 //clock FPGA 50MHz  
	input rst_n,		 //Reset assíncrono ativo-baixo 
	output reg scl,	 //SCL (clock do barramento I2C)  
	inout  sda,			 //SDA (barramento de dados I2C)  
	output [15:0] data //Dado de temperatura  
);

	//Declaração de Registradores
	reg [15:0] data_r;		//Registrador para dado de temperatura
	reg sda_r;					//Registrador para SDA 
	reg sda_link;				//Flag para direção SDA (in/out)
	reg [7:0] scl_cnt;		//contador gerar clock SCL
	reg [2:0] cnt;				//contador auxiliar para clock SCL
	reg [25:0] timer_cnt;	//timer para ler temperatura a cada 1s  
	reg [3:0] data_cnt;		//Registrador para conversão Serial-Paralela
	reg [7:0] addr_reg;		//Endereço do dispositivo I2C
	reg [8:0] estado;			//Registrador para estados
	
	/*INICIO: B1, B2 e B3 - Geração de clk para barramento SCL*/
	//Conta um período de clock de SCL
	`define CNT_OVER 8'd199
	always@(posedge clk or negedge rst_n) begin : B1 
		if (!rst_n) scl_cnt <= 8'd0;  
		else if (scl_cnt == `CNT_OVER) scl_cnt <= 8'd0; //4us (min 2.5ns)
		else scl_cnt <= scl_cnt + 1'b1;  
	end
	//Define transições e níveis do clock SCL, com base no período 
	always@(posedge clk or negedge rst_n) begin : B2 
		if (!rst_n) cnt <= 3'd4;  
		else   
			case(scl_cnt)  
				8'd49  : cnt <= 3'd1;//SCL nível alto  (1us)
				8'd99  : cnt <= 3'd2;//borda de descida SCL (2us)
				8'd149 : cnt <= 3'd3;//SCL nível baixo  (3us)
				8'd199 : cnt <= 3'd0;//borda de subida SCL (4us) 
			   default: cnt <= 3'd4;//SCL indefinido  
			endcase  
	end  
	`define SCL_HIG (cnt == 3'd1) //SCL nível alto (1us)
	`define SCL_NEG (cnt == 3'd2) //na borda de descida SCL (2us) 
	`define SCL_LOW (cnt == 3'd3) //SCL nível baixo (3us)
	`define SCL_POS (cnt == 3'd0) //na borda de subida SCL (4us) 
	
	//produz o sinal de clock na saída SCL
	always@(posedge clk or negedge rst_n) begin : B3
		if (!rst_n) scl <= 1'b0;  
		else if (`SCL_POS) scl <= 1'b1;//após borda subida, scl alto 
		else if (`SCL_NEG) scl <= 1'b0;//após borda descida, scl baixo 
	end  
	/*FIM: B1, B2 e B3 : Gerar clk para barramento SCL*/
	
	/*INICIO: B4 - Leitura de dados de temperatura a cada 1s */
	`define TIMER_OVER 26'd49999999
	always@(posedge clk or negedge rst_n) begin : B4 
		if (!rst_n) timer_cnt <= 26'd0;  //1Hz -> 1seg
		else if (timer_cnt == `TIMER_OVER) timer_cnt <= 26'd0;  
		else timer_cnt <= timer_cnt + 1'b1;  
	end  		
	//Definição da fsm (formato one-hot)
	// vide datasheet LM75A Texas Instrument 
	// SNOS808P –JANUARY 2000–REVISED DECEMBER 2014 PAG 7-8
	// Fig(a) Typical 2-Byte Read From Preset Pointer Location
	localparam 	IDLE  	= 9'b0_0000_0000,  
					START  	= 9'b0_0000_0010, //inicia comunicação com escravo
					ADDRESS	= 9'b0_0000_0100, //envia endereço do escravo  
					ACK1     = 9'b0_0000_1000, //confirmação pelo escravo 
					READ1  	= 9'b0_0001_0000, //leitura do 1byte MSB (temperatura) 
					ACK2     = 9'b0_0010_0000, //confirmação pelo mestre 
					READ2  	= 9'b0_0100_0000, //leitura do 1byte LSB (temperatura)
					NACK     = 9'b0_1000_0000, //mestre não responde ao escravo
					STOP     = 9'b1_0000_0000; //finaliza comunicação com escravo 
				 
	//Endereço do dispositivo _ operação leitura 
	`define DEVICE_ADDRESS 8'b1001_0001 

	//B5 : Descrição da FSM
	always@(posedge clk or negedge rst_n) begin : B5
		if (!rst_n)  
			begin  
				data_r  		<= 16'd0; //limpa o registrador de dados  
				sda_r       <= 1'b1;  //transmite um bit 1
				sda_link    <= 1'b1;  //habilita saída SDA (escrita)
				estado      <= IDLE;  //reinicia a FSM
				addr_reg 	<= 8'd0;  //endereço inicial 0000_0000
				data_cnt    <= 4'd0;  //reinicia contador de dados  
			end  
		else   
			case(estado)  
				IDLE: //Estado Inicial 
					begin  
						sda_r   	<= 1'b1; //transmite um bit 1 
						sda_link <= 1'b1; //habilita saída SDA (escrita)  
						if (timer_cnt == `TIMER_OVER) //periodo concluído  
							estado <= START; //inicia a FSM  
						else  estado <= IDLE;  
					end  
				START://Mestre inicia comunicação com escravo 
					begin  
						if (`SCL_HIG) begin //caso SCL nível alto 
							sda_r       <= 1'b0; //transmite um bit 0 
							sda_link    <= 1'b1; //habilita saída SDA (escrita) 
							addr_reg 	<= `DEVICE_ADDRESS; 
							estado      <= ADDRESS; //próximo estado endereçamento
							data_cnt    <= 4'd0; //reinicia o contador de dados  
						end  
						else estado <= START; //permanece no estado atual 
					end  
				ADDRESS://Mestre envia endereço e operação para escravo
					begin  
						if(`SCL_LOW) begin//caso SCL nível baixo   							  
							//Endereçamento concluído, o SDA muda de direção 
							//e o dispositivo está pronto para emitir um sinal de resposta
							if(data_cnt == 4'd8) begin  
									estado   <= ACK1; //próximo estado, confirmação (ACK) 
									data_cnt <= 4'd0; //reinicia o contador de dados 
									sda_r    <= 1'b1; 
									sda_link <= 1'b0; //SDA alta impedância (leitura) 
							end  
							else begin//Durante o endereçamento, o SDA atua como entrada								 
								estado   <= ADDRESS; //permanence no estado  
								data_cnt <= data_cnt + 1'b1; //incremente o contador de dados  
								case(data_cnt) //conversão paralela-serial, SDA transmite o endereço   
									4'd0: sda_r <= addr_reg[7];  //transmite o MSB do endereço
									4'd1: sda_r <= addr_reg[6];  
									4'd2: sda_r <= addr_reg[5];  
									4'd3: sda_r <= addr_reg[4];  
									4'd4: sda_r <= addr_reg[3];  
									4'd5: sda_r <= addr_reg[2];  
									4'd6: sda_r <= addr_reg[1];  
									4'd7: sda_r <= addr_reg[0]; //transmite o LSB do endereço 
									default: ;  
								endcase  
							end  
						end  
						else  estado <= ADDRESS;  //permanece no estado enquanto SCL nível alto
					end  
				ACK1://Aguarda confirmação do escravo
					begin  
						//inicia a leitura do LSByte
						if ((!sda && (`SCL_HIG))||(`SCL_NEG)) estado <= READ1;  
						else estado <= ACK1; //permanece no estado 
					end  
				READ1://Leitura de dados do escravo, MSB (1byte)
					begin
						//Ao concluir a leitura do MSB 1byte, 
						//o SDA muda de direção e 
						//o host está pronto para emitir um sinal de resposta					
						if((`SCL_LOW) && (data_cnt == 4'd8))
							begin 
								estado   <= ACK2;							
								data_cnt <= 4'd0; //reinicia o contador de dados   
								sda_r    <= 1'b1; //transmite um bit 1  
								sda_link <= 1'b1;	//habilita saída SDA	(escrita)							
							end  
						//Durante a leitura de dados, o dispositivo atua como uma saída
						else if(`SCL_HIG)
							begin  
								data_cnt <= data_cnt + 1'b1; //incrementa o contador de dados  
								case(data_cnt) //conversão serial-paralela  
									4'd0: data_r[15] <= sda; //MSB da leitura (do byte lido)  
									4'd1: data_r[14] <= sda;  
									4'd2: data_r[13] <= sda;  
									4'd3: data_r[12] <= sda;  
									4'd4: data_r[11] <= sda;  
									4'd5: data_r[10] <= sda;  
									4'd6: data_r[9]  <= sda;  
									4'd7: data_r[8]  <= sda; //LSB da leitura (do byte lido) 
									default: ; //sem ação, aguarda próximo valor de data_cnt
								endcase  
							end  
						else  estado <= READ1;  //permanece no estado
					end  
				ACK2://Mestre responde ao escravo
					begin     
						if(`SCL_LOW) sda_r <= 1'b0; //transmite um bit 0  
						else if(`SCL_NEG)  
							begin  
								sda_r    <= 1'b1;   
								sda_link <= 1'b0; //SDA alta impedância (leitura)  
								estado   <= READ2; //próximo estado, leitura LSB 
							end  
						else estado <= ACK2; //permanece no estado 
					end  
				READ2://Leitura de dados do escravo, LSB (1byte)
					begin  
						//Ao concluir a leitura do LSB 1byte, 
						//o SDA muda de direção e 
						//o host está pronto para emitir um sinal de resposta
						if((`SCL_LOW) && (data_cnt == 4'd8)) begin  
							estado   <= NACK; //próximo estado 
							data_cnt <= 4'd0; //reinicia o contador de dados 
							sda_r    <= 1'b1; //transmite um bit 1 
							sda_link <= 1'b1; //habilita saída SDA (escrita)
						end  
						else if(`SCL_HIG)  
							begin  
								data_cnt <= data_cnt + 1'b1; //incrementa o contador de dados 
								case(data_cnt)  //conversão serial-paralela
									4'd0: data_r[7] <= sda; //MSB da leitura (do byte lido) 
									4'd1: data_r[6] <= sda;  
									4'd2: data_r[5] <= sda;  
									4'd3: data_r[4] <= sda;  
									4'd4: data_r[3] <= sda;  
									4'd5: data_r[2] <= sda;  
									4'd6: data_r[1] <= sda;  
									4'd7: data_r[0] <= sda; //LSB da leitura (do byte lido) 
									default: ;  //sem ação, aguarda próximo valor de data_cnt
								endcase  
							end  
						else estado <= READ2; //permanece no estado 
					end  
				NACK://Mestre para de responder ao escravo
					begin  
						if(`SCL_LOW) begin  
								estado <= STOP; //próximo estado 
								sda_r <= 1'b0; //transmite um bit 0   
							end  
						else estado <= NACK; //permanece no estado 
					end  
				STOP: //Finaliza a comunicação com o escravo
					begin  
						if(`SCL_HIG) begin  
							estado <= IDLE; //reinicia a FSM  
							sda_r <= 1'b1; //transmite um bit 1  
						end  
						else estado <= STOP; //permanece no estado  
					end  
				default: estado <= IDLE; //recupera de estado inválido 
			endcase  
	end  
	/*FIM: B4, B5 - Leitura de dados de temperatura a cada 1s */
	
	//Atribuição contínua
	//se sda_link==1 então sda transmite sda_r, caso contrário alta impedância
	assign sda  = sda_link ? sda_r : 1'bz; //infere triestado
	assign data = data_r; //atualiza a saída com os dados lidos (2 Bytes)

endmodule
