module selecao_display (
   input clk,                   // Sinal de clock
   input reset,                 // Sinal de reset
	output reg [2:0] count     // contador 3 bits

);
 

   // Lógica do contador com reset assíncrono
always @(posedge clk or posedge reset) 
begin
   if (reset) 
      count <= 3'b000;  
   else if (count == 3'd5) 
      count <= 3'b000;  
   else
      count <= count + 1;  // Incremento da contagem
end


 
endmodule