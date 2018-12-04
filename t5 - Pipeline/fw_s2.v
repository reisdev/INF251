/*
    forwarding_s2. forwarding for stage for to stage 2
    

*/

`ifndef _forwarding
`define _forwarding

module forwarding (
    input wire [4:0] rt,
    input wire [4:0] rs,
    input wire [4:0] wrreg,
    input wire branch,
    input wire regwr,
    output reg mux_data1,mux_data2
    );

    always @(*) begin
        if(regwr & branch) begin
            if(rs == wrreg)
                mux_data1 <= 1'b1;
            else if(rt == wrreg)
                mux_data2 <= 1'b1;
        end
    end
endmodule 

`endif


