module MUX_controle(
    input wire [7:0] led_db,    // Sinal de entrada do controle IR
    input wire reset, clk,      // Sinais de reset e clock
    output reg [9:0] botao,     // Saídas para os botões numéricos (0-9)
    output reg prev, next, play, defaul, // Saídas para botões de controle
    output reg [1:0] vol,       // Saídas para controle de volume
    output wire chave_alteracao, // Saída para chave de alteração
	 output wire volmais
);

    reg count = 1'b0;
	 reg aux2 = 1'b0;
	 
    assign chave_alteracao = count;
	 assign volmais = aux2;

    always @(posedge clk) 
	 begin
        if (led_db == 8'b1_111_1001) begin  // Serve para o botão 1 ativar a chave de alteração
            count <= ~count;
        end
		   if (led_db == 8'b1_000_0110) begin  // Serve para o botão 1 ativar a chave de alteração
            aux2 <= ~aux2;
        end
    end

    always @(posedge clk) begin
        // Resetando as saídas para garantir que o pulso seja gerado corretamente
        botao <= 10'b0;
        prev <= 1'b0;
        next <= 1'b0;
        play <= 1'b0;
        defaul <= 1'b0;
        vol <= 2'b0;

        case (led_db)
            // Código do controle IR : decodificação BCD7SEG
            8'b1_100_0000: botao[0] <= 1'b1;   // Pulso para o botão 0
            8'b1_111_1001: botao[1] <= 1'b1;   // Pulso para o botão 1
            8'b1_010_0100: botao[2] <= 1'b1;   // Pulso para o botão 2
            8'b1_011_0000: botao[3] <= 1'b1;   // Pulso para o botão 3
            8'b1_001_1001: botao[4] <= 1'b1;   // Pulso para o botão 4
            8'b1_001_0010: botao[5] <= 1'b1;   // Pulso para o botão 5
            8'b1_000_0010: botao[6] <= 1'b1;   // Pulso para o botão 6
            8'b1_111_1000: botao[7] <= 1'b1;   // Pulso para o botão 7
            8'b1_000_0000: botao[8] <= 1'b1;   // Pulso para o botão 8
            8'b1_001_0000: botao[9] <= 1'b1;   // Pulso para o botão 9
            8'b1_010_0000: prev <= 1'b1;       // Pulso para o botão PREV
            8'b1_000_0011: next <= 1'b1;       // Pulso para o botão NEXT
            8'b1_100_0110: play <= 1'b1;       // Pulso para o botão PLAY
            8'b1_010_0001: vol[0] <= 1'b1;     // Pulso para o botão VOL-
            8'b1_000_0110: vol[1] <= 1'b1;     // Pulso para o botão VOL+
            default: defaul <= 1'b1;           // Pulso para a condição default
        endcase
    end
endmodule
