module stream_xbar #(
    parameter  T_DATA_WIDTH = 8,
               S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
               MAX_PACKETS  = 8,
    localparam T_ID_M_WIDTH = $clog2(S_DATA_COUNT),
               T_DEST_WIDTH = $clog2(M_DATA_COUNT)
)(
    input  logic clk,
    input  logic rst_n,
    // multiple input streams
    input  logic [T_DATA_WIDTH-1:0] s_data_i [S_DATA_COUNT-1:0],
    input  logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0],
    input  logic [S_DATA_COUNT-1:0] s_last_i ,
    input  logic [S_DATA_COUNT-1:0] s_valid_i,
    output logic [S_DATA_COUNT-1:0] s_ready_o,
    // multiple output streams
    output logic [T_DATA_WIDTH-1:0] m_data_o [M_DATA_COUNT-1:0],
    output logic [T_ID___WIDTH-1:0] m_id_o   [M_DATA_COUNT-1:0],
    output logic [M_DATA_COUNT-1:0] m_last_o,
    output logic [M_DATA_COUNT-1:0] m_valid_o,
    input  logic [M_DATA_COUNT-1:0] m_ready_i
);

logic [S_DATA_COUNT-1:0] req [M_DATA_COUNT-1:0];
request_gen #(
    .S_DATA_COUNT (S_DATA_COUNT ),
    .M_DATA_COUNT (M_DATA_COUNT )
) u_request_gen(
    .s_dest_i  (s_dest_i  ),
    .s_valid_i (s_valid_i ),
    .req_o     (req       )
);

logic [S_DATA_COUNT-1:0] grant [M_DATA_COUNT-1:0];

genvar i;
generate
    for (i = 0; i < M_DATA_COUNT; i = i + 1) begin
        round_robin #(
            .NUM_REQUEST (S_DATA_COUNT ),
            .MAX_PACKETS (MAX_PACKETS )
        ) u_round_robin (
            .clk       (clk       ),
            .rst_n     (rst_n     ),
            .request_i (req[i]    ),
            .s_last_i  (s_last_i  ),
            .grant_o   (grant[i]  )
        );
    end
endgenerate


com #(
    .T_DATA_WIDTH (T_DATA_WIDTH ),
    .S_DATA_COUNT (S_DATA_COUNT ),
    .M_DATA_COUNT (M_DATA_COUNT )
) u_com(
    .req_i     (grant     ),
    .s_data_i  (s_data_i  ),
    .s_last_i  (s_last_i  ),
    .s_valid_i (s_valid_i ),
    .m_data_o  (m_data_o  ),
    .m_id_o    (m_id_o    ),
    .m_last_o  (m_last_o  ),
    .m_valid_o (m_valid_o ),
    .m_ready_i (m_ready_i )
);

logic [S_DATA_COUNT-1:0] busy_each [M_DATA_COUNT-1:0];

genvar x;
generate
    for (x = 0; x < M_DATA_COUNT; x = x + 1) begin
        assign busy_each[x] = req[x] ^ grant[x]; 
    end
endgenerate

assign s_ready_o[0] = ~(busy_each[0][0] | busy_each [1][0] | busy_each[2][0]);
assign s_ready_o[1] = ~(busy_each[0][1] | busy_each [1][1] | busy_each[2][1]);


endmodule