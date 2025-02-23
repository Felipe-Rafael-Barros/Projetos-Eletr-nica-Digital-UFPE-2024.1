module Estrutura_HarryPotter
(

	output Buzzer, //Saída sonora
	input Clock, stop, play    //Clock 50MHz da placa
);
	
	wire Disparo_est, Saida_est, Saida_msc;     //Sinais auxiliares para interconectar os códigos
	wire [27:0] Overflow_temp_est, Overflow_dc_est;
	
	temporizador_m 	temp( .Saida(Saida_est),            //Mapeamento das entradas e saídas do temporizador
								.Clk(Clock),  
								.Disparo(Disparo_est),
								.Overflow(Overflow_temp_est)
						);
						
	divisorclock_m 	div_clk( .Clk_out(Buzzer),          //Mapeamento das entradas e saídas do divisor de clock 
									.Clk_in(Clock),
									.Overflow(Overflow_dc_est)
						);
	
	HarryPotter 	musica(  .Clk_out(Saida_msc),       //Mapeamento das entradas e saídas do bloco musical
									.Disparo(Disparo_est),
									.stop_in(stop),
									.Play_in(play),
									.Temp_out(Overflow_temp_est),
									.Freq_out(Overflow_dc_est),
									.Clk_in(Clock),
									.Duracao(Saida_est)
						);
	
endmodule