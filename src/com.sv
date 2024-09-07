module com #(
    parameter  T_DATA_WIDTH = 8,
               S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
    localparam T_ID___WIDTH = $clog2(S_DATA_COUNT),
               T_DEST_WIDTH = $clog2(M_DATA_COUNT)
)(
    // multiple input streams
    input  logic [S_DATA_COUNT-1:0] req_i           [M_DATA_COUNT-1:0],
    input  logic [T_DATA_WIDTH-1:0] s_data_i        [S_DATA_COUNT-1:0],
    input  logic [S_DATA_COUNT-1:0] s_last_i ,
    input  logic [S_DATA_COUNT-1:0] s_valid_i,
    // multiple output streams
    output logic [T_DATA_WIDTH-1:0] m_data_o  [M_DATA_COUNT-1:0],
    output logic [T_ID___WIDTH-1:0] m_id_o    [M_DATA_COUNT-1:0],
    output logic [M_DATA_COUNT-1:0] m_last_o,
    output logic [M_DATA_COUNT-1:0] m_valid_o,
    input  logic [M_DATA_COUNT-1:0] m_ready_i
);

logic [T_ID___WIDTH-1:0] num_s [M_DATA_COUNT-1:0];

genvar i;
generate
    for (i = 0; i < M_DATA_COUNT; i = i + 1) begin
        assign num_s[i]     = req_i[i][1] ? 1 :
                              req_i[i][0] ? 0 : 0;
    end
endgenerate

genvar x;
generate
    for (x = 0; x < M_DATA_COUNT; x = x + 1) begin
        assign m_data_o[x]  = s_data_i[num_s[x]];
        assign m_id_o[x]    = num_s[x];
        assign m_last_o[x]  = num_s[x] & s_last_i[num_s[x]];
        assign m_valid_o[x] = num_s[x] & s_valid_i[num_s[x]];

    end
endgenerate


endmodule