module Mux (
    input wire [23:0] horario_relogio,
    input wire [23:0] horario_alarme_1,
    input wire [23:0] horario_alarme_2,
    input wire [23:0] horario_alarme_3,
    input wire botao_pause,
    output reg [23:0] horario_saida,
    output reg comparador1,
    output reg comparador2,
    output reg comparador3,
    input wire clk,
    input wire relogio,
    input wire alarme1,
    input wire alarme2,
    input wire alarme3
);

// Multiplexador 
always @(posedge clk) begin
    if (relogio) 
        horario_saida <= horario_relogio;
    else if (alarme1)
        horario_saida <= horario_alarme_1;
    else if (alarme2)
        horario_saida <= horario_alarme_2;
    else if (alarme3)
        horario_saida <= horario_alarme_3;
end

// Sistema de comparação
always @* begin
    // Reset das saídas do comparador no início do bloco para evitar valores indesejados
    // Verifica a condição do botão pause primeiro
    if (botao_pause) begin
        comparador1 <= 1'b0;
        comparador2 <= 1'b0;
        comparador3 <= 1'b0;
    end
    else if (horario_relogio == horario_alarme_1) begin
        comparador1 <= 1'b1;
    end
    else if (horario_relogio == horario_alarme_2) begin
        comparador2 <= 1'b1;
    end
    else if (horario_relogio == horario_alarme_3) begin
        comparador3 <= 1'b1;
    end
end

endmodule
