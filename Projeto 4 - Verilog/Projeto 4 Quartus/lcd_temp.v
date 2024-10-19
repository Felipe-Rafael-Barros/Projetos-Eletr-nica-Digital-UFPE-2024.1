module lcd_temp (
    input clk,
    input [7:0] seg,      // Ajustado para 7 bits
    input [3:0] dig,
    output reg centena,  // Ajustado para 4 bits
    output reg [3:0] dezena,
    output reg [3:0] unidade,
    output reg [3:0] decimos
);  

reg [3:0] valor_transformado1;
reg [3:0] valor_transformado2;
reg [3:0] valor_transformado3;
reg [3:0] valor_transformado4;

always @(posedge clk) begin
   case (seg[6:0])                          // transformação de 7 segmentos para valores de 4 bits
        7'b1000000 : begin  // 0
            if (dig == 4'b1110) valor_transformado1 <= 4'b0000;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0000;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0000;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0000;
        end
        7'b1111001 : begin  // 1
            if (dig == 4'b1110) valor_transformado1 <= 4'b0001;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0001;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0001;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0001;
        end
        7'b0100100 : begin  // 2
            if (dig == 4'b1110) valor_transformado1 <= 4'b0010;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0010;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0010;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0010;
        end
        7'b0110000 : begin  // 3
            if (dig == 4'b1110) valor_transformado1 <= 4'b0011;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0011;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0011;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0011;
        end
        7'b0011001 : begin  // 4
            if (dig == 4'b1110) valor_transformado1 <= 4'b0100;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0100;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0100;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0100;
        end
        7'b0010010 : begin  // 5
            if (dig == 4'b1110) valor_transformado1 <= 4'b0101;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0101;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0101;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0101;
        end
        7'b0000010 : begin  // 6
            if (dig == 4'b1110) valor_transformado1 <= 4'b0110;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0110;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0110;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0110;
        end
        7'b1111000 : begin  // 7
            if (dig == 4'b1110) valor_transformado1 <= 4'b0111;
            if (dig == 4'b1101) valor_transformado2 <= 4'b0111;
            if (dig == 4'b1011) valor_transformado3 <= 4'b0111;
            if (dig == 4'b0111) valor_transformado4 <= 4'b0111;
        end
        7'b0000000 : begin  // 8
            if (dig == 4'b1110) valor_transformado1 <= 4'b1000;
            if (dig == 4'b1101) valor_transformado2 <= 4'b1000;
            if (dig == 4'b1011) valor_transformado3 <= 4'b1000;
            if (dig == 4'b0111) valor_transformado4 <= 4'b1000;
        end
        7'b0010000 : begin  // 9
            if (dig == 4'b1110) valor_transformado1 <= 4'b1001;
            if (dig == 4'b1101) valor_transformado2 <= 4'b1001;
            if (dig == 4'b1011) valor_transformado3 <= 4'b1001;
            if (dig == 4'b0111) valor_transformado4 <= 4'b1001;
        end
   endcase
   
   // Atribui os valores corretos para os displays
   decimos <= valor_transformado1;
   unidade <= valor_transformado2;
   dezena  <= valor_transformado3;
   centena <= valor_transformado4;
end

endmodule