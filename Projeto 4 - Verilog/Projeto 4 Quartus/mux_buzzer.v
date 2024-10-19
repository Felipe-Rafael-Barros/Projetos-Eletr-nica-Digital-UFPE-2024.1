module mux_buzzer
(
	input clock_in, buzzer_msc1, buzzer_msc2, buzzer_msc3, //Código para jogar na saída apenas a música que estiver sendo executada
	output reg buzzer_para_placa
);

always @(posedge clock_in) begin
                         //De acordo com a selecao, o buzzer da placa irá receber a saída do bloco da musica 1, 2, 3 ou 4.
buzzer_para_placa <= (buzzer_msc1 | buzzer_msc2 | buzzer_msc3);

end
endmodule 