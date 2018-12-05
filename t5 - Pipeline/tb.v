/* 
 code in im_data1.txt ( 8 hexa for mips 32bits instruction)
 size code parameter MMDATA in cpu.v file
 
 compile
 iverilog tb.v cpu.v
 
simule
 vvp a.out
  
visualize
 gtkwave test.vcd

*/

// ---------------- clock generator
module clkGen(out);
output out;
reg    out;
                        //Tested and fully functional
initial begin
        out = 1'b1;
end

always
begin
        out = #1 ~out;
end
endmodule


/* ----------------- module cicle 

module cicle(out);

output out;
reg out;

initial begin
    out <= 32'b0;
end

always @(*)
begin
    out <= out + 32'b1;
end

endmodule

*/

// --------------------------------

module top;

clkGen CLK(clk);
// cicle CLC(cicle);
cpu CPU(clk);
initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,top);
    #30 
    $finish;
    end

endmodule

