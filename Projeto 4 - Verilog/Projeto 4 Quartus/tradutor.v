module lcd_logic_with_conversion (
    input clk,
    input [127:0] input_string, // Entrada de string com 16 caracteres
    output reg [127:0] L1, // Linha 1 do display LCD
    output reg [127:0] L2  // Linha 2 do display LCD
);

    // Função para converter caracteres ASCII em valores de 8 bits e atualizar o registrador
    function [127:0] update_registers;
        input [127:0] str; // String de entrada
        integer i;
        reg [7:0] character;
        begin
            for (i = 0; i < 16; i = i + 1) begin
                character = str[(127 - (i * 8)) -: 8]; // Extrai cada caractere (8 bits)
                update_registers[(127 - (i * 8)) -: 8] = character; // Atribui à posição correspondente do registrador
            end
        end
    endfunction

    always @(posedge clk) begin
        L1 <= update_registers(input_string); // Atualiza a linha 1 do LCD com a string convertida
    end

endmodule
