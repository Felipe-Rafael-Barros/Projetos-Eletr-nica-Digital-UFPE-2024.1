/*---------------------------------
Arquivo:   ir_verilog.v
Modulo:    ir_verilog(clk,rst_n,IR,led_cs,led_db)
Descrição: Controle de Remoto Infravemelho
Autor:     Malki-çedheq Benjamim
Data:      20/01/2022
----------------------------------*/
module ir_verilog(clk,rst_n,IR,led_cs,led_db);

  input   clk; //clock de 50MHz
  input   rst_n; //reset ativo baixo
  input   IR; //entrada de dados irda
  output reg [3:0] led_cs; //4 displays BCD7SEG
  output reg [7:0] led_db; //7 segmentos e ponto de cada display BCD7SEG
 
  reg [7:0] led1,led2,led3,led4; //representa cada display com 7 segmentos
  reg [15:0] irda_data;    // armazena o dado do irda, e então envia para os 7 segmentos
  reg [31:0] get_data;     // armazena os 32 bits do dado do irda
  reg [5:0]  data_cnt;     // contador para os 32 bits do dado do irda
  reg [2:0]  estado_atual, prox_estado; //registradores de estado da FSM
  reg error_flag;          // flag de erro durante os 32 bits de dados do irda

  //----------------------------------------------------------------------------
  reg irda_reg0;       //valor instável
  reg irda_reg1;       //recebe irda_reg0, para estabilização
  reg irda_reg2;       //recebe irda_reg1, auxilia a determinar a borda do irda
  wire irda_negedge; //determina a borda de descida do irda
  wire irda_posedge; //determina a borda de subida do irda
  wire irda_change;    //determina a transição de borda do irda
  
  //reg[15:0] cnt_scan;//ɨ��Ƶ�ʼ�����
   
  always @ (posedge clk) //sincroniza os registradores do irda
    if(!rst_n) //reset assincrono dos registradores do irda
      begin
        irda_reg0 <= 1'b0; //limpa o registrador irda_reg0
        irda_reg1 <= 1'b0; //limpa o registrador irda_reg1
        irda_reg2 <= 1'b0; //limpa o registrador irda_reg2
      end
    else
      begin
        led_estado_atual<= 4'b0000; //atualiza os registradores do irda na borda de subida do clk
        irda_reg0 <= IR; //recebe o valor lido irda
        irda_reg1 <= irda_reg0; //atualiza com valor estável
        irda_reg2 <= irda_reg1; // atualiza garantindo valor estável de IR
      end
     
  assign irda_change = irda_negedge | irda_posedge; //atribui 1 numa transição de borda de irda
  assign irda_negedge = irda_reg2 & (~irda_reg1);   //atribui 1 na borda de descida de irda
  assign irda_posedge = (~irda_reg2) & irda_reg1;   //atribui 1 na borda de descida de irda

  reg [10:0] cnt1;      //Divisor de frequência por 1750
  reg [8:0]  cnt2;      //conta o número de pontos após o cnt1
  wire verifica_900us;  // verifica a duração de 9ms = 900us
  wire verifica_450us;  // verifica a duração de 4.5ms = 450us
  
  //Lógico '1' – uma rajada de pulso de 562,5µs seguida por um espaço de 1,6875ms, com um tempo total de transmissão de 2,25ms
  wire high;            // verifica  data="1"
  //Lógico '0' – uma rajada de pulso de 562,5µs seguida por um espaço de 562,5µs, com um tempo total de transmissão de 1,125ms
  wire low;             // verifica  data="0"

 
  //----------------------------------------------------------------------------
  always @ (posedge clk)
    if (!rst_n) //reset assíncrono
      cnt1 <= 11'd0; //reinicia o contador 1
    else if (irda_change) //na transição de borda de irda
      cnt1 <= 11'd0; //reinicia o contador 1
    else if (cnt1 == 11'd1750) //caso contador estoure
      cnt1 <= 11'd0; //reinicia o contador 1
    else
      cnt1 <= cnt1 + 1'b1; // incrementa o contador 1
  //----------------------------------------------------------------------------

  //---------------------------------------------------------------------------- 
  always @ (posedge clk)
    if (!rst_n) //reset assíncrono
      cnt2 <= 9'd0; //reinicia o contador 2
    else if (irda_change) //na transição de borda de irda
      cnt2 <= 9'd0; //reinicia o contador 2
    else if (cnt1 == 11'd1750) //1750 pulso nível baixo e 1750 pulsos nível alto
      cnt2 <= cnt2 +1'b1; //incrementa o contador 2
   //----------------------------------------------------------------------------

  //Garante a estabilidade avaliando intervalo de contagem inves do valor exato
  assign verifica_900us = ((217 < cnt2) & (cnt2 < 297));// valor exato esperado 256 
  assign verifica_450us = ((88 < cnt2) & (cnt2 < 168)); // valor exato esperado 128  
  assign high = ((38 < cnt2) & (cnt2 < 58));            // valor exato esperado 48
  assign low  = ((6 < cnt2) & (cnt2 < 26));             // valor exato esperado 16

  //----------------------------------------------------------------------------
  // Declaração da FSM
  localparam IDLE_STATE   = 3'b000, //estado inicial
            ATRASO_900us  = 3'b001, //atraso de 900us
            ATRASO_450us  = 3'b010, //atrado de 450us
            DATA_STATE    = 3'b100; //estado de transferência de dados
 
  //FSM Lógica para controle do estado atual (sequencial)
  always @ (posedge clk)
    if (!rst_n) //reset assíncrono
      estado_atual <= IDLE_STATE; //reinicia a FSM
    else
      estado_atual <= prox_estado; //atualiza o estado atual
  
  //FSM Lógica para controle do estado atual (combinacional)
  always @ ( * )
    case (estado_atual)
      IDLE_STATE://quando no estado inicial
        if (~irda_reg1)
          prox_estado = ATRASO_900us; //passa ao estado seguinte
        else 
          prox_estado = IDLE_STATE; //reinicia a FSM
   
      ATRASO_900us: //quando no estado de atraso de 900us
        if (irda_posedge)
          begin
            if (verifica_900us)
              prox_estado = ATRASO_450us; //passa ao estado seguinte
            else
              prox_estado = IDLE_STATE; //reinicia a FSM
          end
        else  //previne inferência de latches
          prox_estado = ATRASO_900us; //permanece no estado atual
   
      ATRASO_450us: //quando no estado de atraso de 450us
        if (irda_negedge)
          begin
            if (verifica_450us)
              prox_estado = DATA_STATE; //passa ao estado seguinte
            else
              prox_estado = IDLE_STATE; //reinicia a FSM
          end
        else //previne inferência de latches
          prox_estado = ATRASO_450us; //permanece no estado atual
   
      DATA_STATE: //quando no estado de transferência de dados
        if ((data_cnt == 6'd32) & irda_reg2 & irda_reg1) //verifica se recebeu os 32 bits
          prox_estado = IDLE_STATE; //passa ao estado seguinte
        else if (error_flag) //caso apresente erro nos dados de irda
          prox_estado = IDLE_STATE;  //reinicia a FSM
        else
          prox_estado = DATA_STATE; //permanece no estado atual
      default:
        prox_estado = IDLE_STATE; //recupera de estado inválido, reiniciando a FSM
    endcase

  //FSM Lógica para controle das saídas
  always @ (posedge clk)
    if (!rst_n) //reset assíncrono
      begin
        data_cnt <= 6'd0; //reinicia o contador de bits de dados irda
        get_data <= 32'd0; //limpa os registradores para os 32 bits de dados irda
        error_flag <= 1'b0; //limpa a flag de erro de dados irda
      end
    else if (estado_atual == IDLE_STATE) //quando no estado inicial
      begin
        data_cnt <= 6'd0; //reinicia o contador de bits de dados irda
        get_data <= 32'd0; //limpa os registradores para os 32 bits de dados irda
        error_flag <= 1'b0; //limpa a flag de erro de dados irda
      end
    else if (estado_atual == DATA_STATE) //quando no estado de transmissão de dados
      begin
        if (irda_posedge)  //verifica se é borda de subida
          begin
            if (!low)  //caso não seja nível lógico baixo (nível lógico 0, 560us)
              error_flag <= 1'b1; //define flag de erro
          end
        else if (irda_negedge)  //verifica se é borda de descida
          begin
            if (low) //caso seja nível lógico baixo (nível lógico 0, 560us)
              get_data[0] <= 1'b0;
            else if (high) //caso seja nível lógico alto (nível lógico 1, 1680us)
              get_data[0] <= 1'b1;
            else
              error_flag <= 1'b1; //caso contrário, define flag de erro
             
            get_data[31:1] <= get_data[30:0]; //atualiza o registrador de dados, deslocando 1 bit
            data_cnt <= data_cnt + 1'b1; //incrementa o contador de dados
          end
      end

  
  //Lógica para o controle dos displays BCD7SEG ----------------------------
  always @ (posedge clk)
    if (!rst_n)
      irda_data <= 16'd0;
    else if ((data_cnt ==6'd32) & irda_reg1)
  begin
    led1 <= get_data[7:0];  //Complemento dos dados
    led2 <= get_data[15:8]; //Código dos dados
    led3 <= get_data[23:16];//Código de usuário
    led4 <= get_data[31:24];
  end
 
  //Exibe nos display de BCD7SEG a tecla pressionado no controle remoto IR
  always@(led2) 
  begin
    case(led2)
    //código no controle IR : decodificação BCD7SEG
      8'b01101000: led_db = 8'b1100_0000;  //exibe 0 no display
      8'b00110000: led_db = 8'b1111_1001;  //exibe 0 no display
      8'b00011000: led_db = 8'b1010_0100;  //exibe 0 no display
      8'b01111010: led_db = 8'b1011_0000;  //exibe 0 no display
      8'b00010000: led_db = 8'b1001_1001;  //exibe 0 no display
      8'b00111000: led_db = 8'b1001_0010;  //exibe 0 no display
      8'b01011010: led_db = 8'b1000_0010;  //exibe 0 no display
      8'b01000010: led_db = 8'b1111_1000;  //exibe 0 no display
      8'b01001010: led_db = 8'b1000_0000;  //exibe 0 no display
      8'b01010010: led_db = 8'b1001_0000;  //exibe 0 no display   
      default:     led_db = 8'b1000_1110;  //exibe F no display
    endcase
  end

endmodule 


