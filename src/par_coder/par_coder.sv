// generated code

module par_coder #(
    parameter  S_DATA_COUNT = 2,
    localparam T_ID_M_WIDTH = $clog2(S_DATA_COUNT)
)(
    // input
    input  logic [S_DATA_COUNT-1:0] m_vec_i,
    // output
    output logic [T_ID_M_WIDTH-1:0] m_id 
);

assign m_id =   (m_vec_i[1] ?  1 : 0)
              | (m_vec_i[0] ?  0 : 0);

endmodule