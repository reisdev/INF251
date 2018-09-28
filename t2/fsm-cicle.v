module ff ( input data, input c, input r, output q);
reg q;
always @(posedge c or negedge r) 
begin
 if(r==1'b0)
  q <= 1'b0; 
 else 
  q <= data; 
end 
endmodule //End 

// ----   FSM alto nível com Case
module statem(clk, reset,a, saida);
input clk, reset,a;
output [2:0] saida;
reg [2:0] state;  // 3 bits de estado
parameter zero = 3'b000, two=3'b010,three=3'b011,four=3'b100,five=3'b101,six = 3'b110;

assign saida = (state == zero) ? 3'd2 :
           (state == two)? 3'd6:
           (state == three)? 3'd5:
           (state == four) ? 3'd4 :
           (state == five) ? 3'd5 : 3'd6;   

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
               case (state)
                    zero:  state = two;
                    two:   state = five;
                    three: state = six;
                    four:  state = two;
                    five: 
                      if(a == 1) state = three;
                      else state = six;
                    six:   state = four;
               endcase
     end
endmodule

// FSM com portas logicas , total de 22 operadores
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;

assign s = e;
assign p[2] = (e[1] & e[0] ^ a); // 3 operadores
assign p[1] = (~e[2] & ~e[1] & ~a) | (e[1] & ~e[0] & ~a) | (e[2] & ~a); // 13 operadores
assign p[0] = (e[2] & e[0] | e[1] & ~e[0]) | (e[2] & a); // 6 operadores

// 22 operadores lógicos

ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);

endmodule 

module stateMem(input clk,input res, input a, output [2:0] s);
reg [5:0] StateMachine [0:15]; // 16 linhas de memória, com 6 bits de largura

initial
begin  // Codificar as linhas da memória
StateMachine[0] = 6'd8;  StateMachine[1] = 6'd17;
StateMachine[2] = 6'd29;  StateMachine[3] =  6'd37;
StateMachine[4] =  6'd12;  StateMachine[5] = 6'd8;
StateMachine[6] = 6'd8;  StateMachine[7] = 6'd8;
StateMachine[8] = 6'd8;  StateMachine[9] = 6'd8; 
StateMachine[10] = 6'd45; StateMachine[11] = 6'd14;
StateMachine[12] = 6'd20; StateMachine[13] = 6'd29;
StateMachine[14] = 6'd8; StateMachine[15] = 6'd8;
end

wire [3:0] address; // 16 linhas , 4 bits de endereco
wire [5:0] dout;  // 6 bits de largura , 3 do próx e 3 da saída

assign address[3] = a;
assign dout = StateMachine[address];
assign s = dout[2:0]; // Saída são os 3 primeiros bits do dout

// ff para repassar o próximo estado para o e2e1e0
ff st0(dout[3],clk,res,address[0]);
ff st1(dout[4],clk,res,address[1]);
ff st2(dout[5],clk,res,address[2]);

endmodule

module main;
reg c,res,a;
wire [2:0] s;
wire [2:0] s1;
wire [2:0] s2;
statem FSM(c,res,a,s);
statePorta FSM1(c,res,a,s1);
stateMem FSM2(c,res,a,s2);

initial
    c = 1'b0;
  always
    c= #(1) ~c;

// visualizar formas de onda usar gtkwave out.vcd
initial  begin
     $dumpfile ("out.vcd"); 
     $dumpvars; 
   end 

  initial 
    begin
     $monitor($time," c %b res %b a %b FSM %d Portas %d Mem %d",c,res,a,s,s1,s2);
        #1 res=0; a=0;
        #1 res=1;
        #8 a=1;
        #16 a=0;
        #12 a=1;
        #4;
        $finish ;
    end
endmodule

