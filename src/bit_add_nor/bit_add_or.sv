module bit_add_or #(
    parameter NUM_TERMS = 3
)(
    // input
    input  logic [NUM_TERMS-1:0] terms_i,
    // output
    output logic                 res 
);

assign res =   terms_i[2]
             | terms_i[1]
             | terms_i[0];

endmodule