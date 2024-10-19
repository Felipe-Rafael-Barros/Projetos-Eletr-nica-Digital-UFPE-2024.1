module contador4bits(
   input clk,                   // Sinal de clock
   input decrescente,           // Sinal de controle (0 para contagem crescente, 1 para decrescente)
   input resetar,               // Sinal de reset
   input [3:0] max_value,       // Valor máximo da contagem
   output reg reset,            // Sinal de reset da contagem
   output reg [3:0] count       // Saída do contador de 4 bits
);

   // Lógica do contador
   always @(posedge clk or posedge resetar) begin
      if (resetar) begin
         count <= 4'b0000;      // Reseta o contador para zero
         reset <= 1'b0;         // Indica que houve um reset
      end else begin
         if (decrescente) begin
            if (count == 4'b0000) begin
               count <= max_value; // Reseta para o valor máximo quando atinge o mínimo
               reset <= 1'b1;
            end else begin
               count <= count - 1; // Contagem decrescente
               reset <= 1'b0;
            end
         end else begin
            if (count == max_value) begin
               count <= 4'b0000;   // Reseta para zero ao atingir o valor máximo
               reset <= 1'b1;
            end else begin
               count <= count + 1; // Contagem crescente
               reset <= 1'b0;
            end
         end
      end
   end
endmodule
