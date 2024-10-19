module relogio(
   input wire clk, clk50mhz,                  // Sinal de clock
	input wire ENA,          // Sinal de controle (0 para contagem crescente, 1 para decrescente)
	input wire [3:1] botao,
	input wire chave_alteracao,
	input wire[2:0] seletor,
	input wire relogio_ativo,
   output reg [23:0] relogio_completo
);

    // Sinais intermediários para o reset dos contadores
wire  carry_min;
reg clock[6:1];
wire reset[6:1];
reg incremento = 1'b0;
wire [23:0] relogio_parcial;
wire [3:0] seg_unidade, seg_dezena, min_unidade, min_dezena, hora_unidade, hora_dezena;    // Dezena das horas (0-2)
assign relogio_parcial = {hora_dezena[3:0],hora_unidade[3:0],min_dezena[3:0],min_unidade[3:0],seg_dezena[3:0],seg_unidade[3:0]};
	


		// Contador de unidades dos segundos (0-9)
contador4bits contador_seg_unidade (
   .clk(clock[1]),
   .decrescente(ENA),
	.resetar(1'b0), //condição para resetar caso necessário
   .max_value(4'd9),       // Valor máximo para unidades dos segundos
	.reset(reset[1]),
   .count(seg_unidade)
);

    // Contador de dezenas dos segundos (0-5)
contador4bits contador_seg_dezena (
   .clk(clock[2]),
   .decrescente(ENA),
	.resetar(1'b0), //condição para resetar caso necessário
   .max_value(4'd5),       // Valor máximo para dezenas dos segundos
   .reset(reset[2]),
	.count(seg_dezena)
   );
    

    // Contador de unidades dos minutos (0-9)
contador4bits contador_min_unidade (
   .clk(clock[3]),
   .decrescente(ENA),
	.resetar(1'b0), //condição para resetar caso necessário
   .max_value(4'd9),       // Valor máximo para unidades dos minutos
   .reset(reset[3]),
	.count(min_unidade)
);

    // Contador de dezenas dos minutos (0-5)
contador4bits contador_min_dezena (
   .clk(clock[4]),
   .decrescente(ENA),
	.resetar(1'b0), //condição para resetar caso necessário
   .max_value(4'd5),       // Valor máximo para dezenas dos minutos
   .reset(reset[4]),
	.count(min_dezena)
);

assign carry_min = ((relogio_completo[23:20] == 4'd2) && (relogio_completo[19:16] >= 4'd4)) ;  // Carry para horas

    // Contador de unidades das horas (0-9) ou (0-3)
contador4bits contador_hora_unidade (
   .clk(clock[5]),
   .decrescente(ENA),
	.resetar(carry_min), //condição para resetar caso necessário
   .max_value(4'd9),       // Valor máximo para unidades das horas
   .reset(reset[5]),
	.count(hora_unidade)
);

    // Contador de dezenas das horas (0-2)
contador4bits contador_hora_dezena (
   .clk(clock[6]),
   .decrescente(ENA),
	.resetar(carry_min), //condição para resetar caso necessário
   .max_value(4'd2),       // Valor máximo para dezenas das horas
   .reset(reset[6]),
	.count(hora_dezena)
);

	
always @(posedge clk50mhz or posedge seletor) 
begin	
	relogio_completo <= relogio_parcial;

	
	case (chave_alteracao) 
		0: 
		begin
			clock[1] <= clk;  
			clock[2] <= reset[1]; 
			clock[3] <= reset[2]; 
			clock[4] <= reset[3]; 
			clock[5] <= reset[4]; 
			clock[6] <= reset[5];
		end
		1: 
		begin
			if (relogio_ativo) begin
				incremento <= botao[2]; //define o incremento como o botão 2
			end
			else begin
				incremento <= 1'b0;
			end
			case (seletor)
					
					3'd0: begin    clock[1] <= incremento;clock[2] <= 1'b0;clock[3] <= 1'b0;clock[4] <= 1'b0;clock[5] <= 1'b0;clock[6] <= 1'b0; end
					
					3'd1: begin    clock[1] <= 1'b0;clock[2] <= incremento;clock[3] <= 1'b0;clock[4] <= 1'b0;clock[5] <= 1'b0;clock[6] <= 1'b0; end
					
					3'd2: begin    clock[1] <= 1'b0;clock[2] <= 1'b0;clock[3] <= incremento;clock[4] <= 1'b0;clock[5] <= 1'b0;clock[6] <= 1'b0; end
					
					3'd3: begin    clock[1] <= 1'b0;clock[2] <= 1'b0;clock[3] <= 1'b0;clock[4] <= incremento;clock[5] <= 1'b0;clock[6] <= 1'b0; end
					
					3'd4: begin    clock[1] <= 1'b0;clock[2] <= 1'b0;clock[3] <= 1'b0;clock[4] <= 1'b0;clock[5] <= incremento;clock[6] <= 1'b0; end
					
					3'd5: begin    clock[1] <= 1'b0;clock[2] <= 1'b0;clock[3] <= 1'b0;clock[4] <= 1'b0;clock[5] <= 1'b0;clock[6] <= incremento; end
					
					default: begin clock[1] <= 1'b0;clock[2] <= 1'b0;clock[3] <= 1'b0;clock[4] <= 1'b0;clock[5] <= 1'b0;clock[6] <= 1'b0; end
						
			endcase
	
		end	
	endcase
end
   

endmodule