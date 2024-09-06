module conflict_finder #(
    parameter  S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
    localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT)
)(
    input  logic clk,
    input  logic rst_n,
    // input
    input  logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0],
    // output
    output logic [M_DATA_COUNT-1:0] conflict_o
);

integer i, j;

always_comb begin : conflict_vector
    conflict_o = 0;

    for (i = 0; i < S_DATA_COUNT; i = i + 1) begin
        for (j = i + 1; j < S_DATA_COUNT; j = j + 1) begin
            if (s_dest_i[i] == s_dest_i[j]) begin
                conflict_o[s_dest_i[i]] = 1;
                conflict_o[s_dest_i[j]] = 1;
            end else begin
                conflict_o[s_dest_i[i]] = 0;
                conflict_o[s_dest_i[j]] = 0;
            end
        end
    end
end

endmodule