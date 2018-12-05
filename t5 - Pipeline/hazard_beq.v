/*

    Hazard module for preventing beq problems

    Author(s): Matheus dos Reis <matheusdrdj@gmail.com>
               Lucas Matos <>

*/

`ifndef _hazard
`define _hazard

module hazard(
    input wire [4:0] rs_id,
    input wire [4:0] rt_id,
    input wire [4:0] reg_id,
    input wire condition,
    input wire branch,
    output reg stall_s2, hold_haz
);

    always @(*) begin
        if(branch == 1'b1 && condition == 1'b1)
            if(rs_id == reg_id || rt_id == reg_id) begin
                hold_haz <= 1'b1;
                stall_s2 <= 1'b1;
            end
    end

endmodule

`endif

