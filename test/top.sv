module top;

// Parameters
localparam T_DATA_WIDTH = 8;
localparam S_DATA_COUNT = 2;
localparam M_DATA_COUNT = 3;
localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT);

// Inputs
reg clk;
reg rst_n;
reg [T_DATA_WIDTH-1:0] s_data_i [S_DATA_COUNT-1:0];
reg [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0];
reg [S_DATA_COUNT-1:0] s_last_i;
reg [S_DATA_COUNT-1:0] s_valid_i;
reg [M_DATA_COUNT-1:0] m_ready_i;

// Outputs
wire [S_DATA_COUNT-1:0] s_ready_o;
wire [T_DATA_WIDTH-1:0] m_data_o [M_DATA_COUNT-1:0];
wire [$clog2(S_DATA_COUNT)-1:0] m_id_o [M_DATA_COUNT-1:0];
wire [M_DATA_COUNT-1:0] m_last_o;
wire [M_DATA_COUNT-1:0] m_valid_o;

// Instantiate the stream_xbar
stream_xbar #(
    .T_DATA_WIDTH(T_DATA_WIDTH),
    .S_DATA_COUNT(S_DATA_COUNT),
    .M_DATA_COUNT(M_DATA_COUNT)
) uut (
    .clk(clk),
    .rst_n(rst_n),
    .s_data_i(s_data_i),
    .s_dest_i(s_dest_i),
    .s_last_i(s_last_i),
    .s_valid_i(s_valid_i),
    .s_ready_o(s_ready_o),
    .m_data_o(m_data_o),
    .m_id_o(m_id_o),
    .m_last_o(m_last_o),
    .m_valid_o(m_valid_o),
    .m_ready_i(m_ready_i)
);

// Clock generation
always #1 clk = ~clk;

// Function to display test results
task display_test_result;
    input [7:0] test_number;
    input [7:0] expected_data;
    input [7:0] actual_data;
    input expected_valid;
    input actual_valid;
    input expected_id;
    input actual_id;
    input [T_DATA_WIDTH-1:0] master_data_0;
    input [T_DATA_WIDTH-1:0] master_data_1;
    input [T_DEST_WIDTH-1:0] master_dest_0;
    input [T_DEST_WIDTH-1:0] master_dest_1;
    input valid_input_0;
    input valid_input_1;

    begin
        $display("Test %0d:", test_number);
        $display("Master Data: %h, %h", master_data_0, master_data_1);
        $display("Master Dest: %d, %d", master_dest_0, master_dest_1);
        $display("Master Valid: %b, %b", valid_input_0, valid_input_1);
        $display("Expected Data: %h, Actual Data: %h", expected_data, actual_data);
        $display("Expected Valid: %b, Actual Valid: %b", expected_valid, actual_valid);
        $display("Expected ID: %d, Actual ID: %d", expected_id, actual_id);
        $display("");
    end
endtask

initial begin
    // Initialize Inputs
    clk = 0;
    rst_n = 0;
    s_data_i[0] = 0;
    s_data_i[1] = 0;
    s_dest_i[0] = 0;
    s_dest_i[1] = 0;
    s_last_i = 0;
    s_valid_i = 0;
    m_ready_i = 0;

    // Apply Reset
    #5  rst_n = 1;

    // Test 1: Master 0 sends data to Slave 0; Master 1 sends data to Slave 0
    s_data_i[0] = 8'hAA;
    s_dest_i[0] = 0;
    s_valid_i[0] = 1;
    m_ready_i[0] = 1;
    s_last_i[0] = 1;


    s_data_i[1] = 8'hBB;
    s_dest_i[1] = 0;
    s_valid_i[1] = 1;
    m_ready_i[1] = 1;
    s_last_i[1] = 1;

    #1;
    s_valid_i[0] = 0;
    #1;
    s_valid_i[1] = 0;

end

endmodule
