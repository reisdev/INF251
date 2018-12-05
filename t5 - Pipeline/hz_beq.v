/*

    Hazard module for preventing beq problems

    Author(s): Matheus dos Reis <matheusdrdj@gmail.com>
               Lucas Matos <>

*/

`ifndef _hazard
`define _hazard

module hazard(
    input wire [4:0] rs_s2,
    input wire [4:0] rt_s2,
    input wire [4:0] reg_s3,
    input wire rgwrite_s3,
    input wire branch,
    output reg stall_s2, hold_haz
);

    always @(*) begin
        if(branch == 1'b1)
            if(rs_s2 == reg_s3 || rt_s2 == reg_s3) begin
                hold_haz <= 1'b1;
                stall_s2 <= 1'b1;
            end
    end

endmodule

`endif

