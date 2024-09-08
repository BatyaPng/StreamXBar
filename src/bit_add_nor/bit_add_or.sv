// generated code

module bit_add_or #(
    parameter NUM_TERMS = 2
)(
    // input
    input  logic [NUM_TERMS-1:0] terms_i,
    // output
    output logic                 res_o 
);

assign res =   terms_i[1]
             | terms_i[0];

endmodule