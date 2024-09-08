module fixed_prio_arb #(
    parameter NUM_REQUEST = 4
)(
    // input    
    input  logic [NUM_REQUEST-1:0] request_i,
    // output
    output logic [NUM_REQUEST-1:0] grant_o
);

assign grant_o[0]  = request_i[0];
assign grant_o[1]  = request_i[1] & ~request_i[0];
// assign grant_o[2]  = request_i[2] & ~request_i[1] & ~request_i[0];
// assign grant_o[3]  = request_i[3] & ~request_i[2] & ~request_i[1] & ~request_i[0];

endmodule