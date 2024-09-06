module request_gen #(
    parameter  S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
    localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT)
)(
    input  logic clk,
    input  logic rst_n,
    // input
    input  logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0],
    input  logic [T_DEST_WIDTH-1:0] num_slave,
    // output
    output logic [S_DATA_COUNT-1:0] req_o
);

integer i;

always_comb begin : req_vector
    req_o = 0;

    for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
        if (s_dest_i[i] == num_slave) begin
            req_o[i] = 1;
        end
    end
end
    
endmodule