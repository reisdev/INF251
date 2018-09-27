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
module statem(clk, reset,a, s);
input clk, reset,a;
output [2:0] s;
reg [2:0] state;  // 3 bits de estado
parameter zero=3'd0,tres=3'd1,dois=3'd2,quatro=3'b011,cinco=3'b100;

assign s = (state == zero)? 3'd0:
           (state == dois)? 3'd2:
           (state == tres)? 3'd3:
           (state == quatro)? 3'd4:3'd5;   

always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero; // arbitrario neste exemplo, nao especificado...
          else
               case (state)
                    zero: state = tres;
                    tres:
                         if ( a == 1 ) state = cinco;
			 else state = dois;
                    dois: state = quatro;
                    quatro:
                         if ( a == 1 ) state = tres;
			 else state = zero;                   
                    cinco: state = dois;
               endcase
     end
endmodule
// FSM com portas logicas
// programar ainda....
module statePorta(input clk, input res, input d, output t);
wire [1:0] e;
wire [1:0] p;
assign red = e[1];
assign yellow = e[0];
assign p = { e[0], ~(e[0]|e[1])};
assign green  = p[0]; 
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
endmodule 




module stateMem(input clk,input res, input a, output [2:0] s);
reg [5:0] StateMachine [0:15];
initial
begin  // programar ainda....
StateMachine[0] = 6'd8;  StateMachine[1] = 6'd8;
StateMachine[2] = 6'd19;  StateMachine[3] =  6'd35;
StateMachine[4] =  6'h1A;  StateMachine[5] = 6'h1A;
StateMachine[6] = 6'd4;  StateMachine[7] = 6'd12;
StateMachine[8] = 6'h15;  StateMachine[9] = 6'h15; 
end
wire [3:0] address; // 16 linhas , 4 bits de endereco
wire [5:0] dout;  // 6 bits de largura
assign address[0] = a;
assign dout = StateMachine[address];
assign s = dout[2:0];
ff st0(dout[3],clk,res,address[1]);
ff st1(dout[4],clk,res,address[2]);
ff st2(dout[5],clk,res,address[3]);
endmodule

module main;
reg c,res,a;
wire [2:0] s;
wire [2:0] s1;
statem FSM(c,res,a,s);
//statePorta FSM(c,res,g,r,y);
stateMem FSM1(c,res,a,s1);


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
     $monitor($time," c %b res %b a %b s %d s1 %d",c,res,a,s,s1);
      #1 res=0; a=0;
      #1 res=1;
      #10 a=1; // depois de 5 "clocks", cada clock 2 unidades de tempo
      #10;
      $finish ;
    end
endmodule

