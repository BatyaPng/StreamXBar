module request_gen #(
    parameter  S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
    localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT)
)(
    // input
    input  logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0],
    input  logic [S_DATA_COUNT-1:0] s_valid_i,
    // output
    output logic [S_DATA_COUNT-1:0] req_o [M_DATA_COUNT-1:0]
);


genvar i, j;
generate
    for (i = 0; i < M_DATA_COUNT; i = i + 1) begin
        for (j = 0; j < S_DATA_COUNT; j = j + 1) begin
            assign req_o[i][j] = (s_dest_i[j] == i) & (s_valid_i[j]);        
        end  
    end
endgenerate

endmodule