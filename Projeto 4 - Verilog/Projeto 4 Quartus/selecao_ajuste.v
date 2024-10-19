module selecao_ajuste (
   input clk,                   // Sinal de clock
   input reset,                 // Sinal de reset
   output reg relogio,
   output reg alarme_1,
   output reg alarme_2,
   output reg alarme_3
);
   reg [1:0] count;

   // Lógica do contador com reset assíncrono
   always @(posedge clk or posedge reset) begin
      if (reset) 
         count <= 2'd0;  
      else if (count == 2'd3) 
         count <= 2'd0;  
      else
         count <= count + 1;  // Incremento da contagem
   end

   // Seleção das saídas com base no valor do contador
   always @(*) begin
      case (count) 
         2'd0 : begin relogio = 1'b1; alarme_1 = 1'b0; alarme_2 = 1'b0; alarme_3 = 1'b0; 
         end
         2'd1 : begin relogio = 1'b0; alarme_1 = 1'b1; alarme_2 = 1'b0; alarme_3 = 1'b0; 
         end
         2'd2 : begin relogio = 1'b0; alarme_1 = 1'b0; alarme_2 = 1'b1; alarme_3 = 1'b0; 
         end
         2'd3 : begin relogio = 1'b0; alarme_1 = 1'b0; alarme_2 = 1'b0; alarme_3 = 1'b1; 
         end
         default: begin relogio = 1'b0; alarme_1 = 1'b0; alarme_2 = 1'b0; alarme_3 = 1'b0; 
         end
      endcase
   end
endmodule