module selecao_de_musica_alarmes
(
	input clock_in,
	input comparador_1,
	input comparador_2,
	input comparador_3,
	
	output reg clock_mus1, clock_mus2, clock_mus3
		
);



always @(posedge clock_in) begin

	clock_mus1 = (comparador_1 & clock_in);
	clock_mus2 = (comparador_2 & clock_in);
	clock_mus3 = (comparador_3 & clock_in);

end
endmodule 