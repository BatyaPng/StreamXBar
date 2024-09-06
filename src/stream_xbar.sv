module stream_xbar #(
    parameter  T_DATA_WIDTH = 8,
               S_DATA_COUNT = 2,                                  // кол-во master устройств
               M_DATA_COUNT = 3,                                  // кол-во slave  устройств
    localparam T_ID___WIDTH = $clog2(S_DATA_COUNT),
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
