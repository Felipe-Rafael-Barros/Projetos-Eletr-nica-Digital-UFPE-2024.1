module divisordeclock #(
    parameter Contagem = 10,  		// módulo da contagem
    parameter n = 5                // Número de bits do contador
) (
    input wire clk_in,               
    input wire reset,                
    output reg clk_out              
);
	 reg [n-1:0] aux_contagem = Contagem;
    reg [n-1:0] counter = 0;         // Contador dinâmico de acordo com o número de bits definido
												// Processo síncrono controlado pela borda de subida do clock de entrada
    always @(posedge !clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;             // Reset do contador
            clk_out <= 0;             // Reset do clock de saída
        end else begin
            if (counter == aux_contagem-1) begin
                counter <= 0;         // Reinicia o contador
                clk_out <= (~clk_out);  // Inverte o clock de saída
            end else begin
                counter <= counter + 1; // Incrementa o contador
            end
        end
    end

endmodule