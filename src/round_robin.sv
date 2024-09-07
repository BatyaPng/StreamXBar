module round_robin #(
    parameter  NUM_REQUEST       = 4,
    parameter  MAX_PACKETS       = 8,
    localparam WIDTH_NUM         = $clog2(NUM_REQUEST),
    localparam WIDTH_MAX_PACKETS = $clog2(MAX_PACKETS)
)(
    input  logic clk,
    input  logic rst_n,
    // input
    input  logic [NUM_REQUEST-1:0] request_i,
    input  logic [NUM_REQUEST-1:0] s_last_i,
    // output
    output logic [NUM_REQUEST-1:0] grant_o
);

reg [WIDTH_MAX_PACKETS-1:0] num_packet;
always @(posedge clk) begin
    if (!rst_n) begin
        num_packet <= 0;
    end else if (s_last_i[grant_ptr]) begin
        num_packet <= 0;
    end else begin
        num_packet <= num_packet + 1;
    end
end

reg [NUM_REQUEST-1:0] grant_ptr_vec;
always @(posedge clk) begin
    if (!rst_n) begin
        grant_ptr_vec <= 0;
    end else if (num_packet == 0) begin
        grant_ptr_vec <= grant_fixed_vec << prio_ptr;
    end else begin
        grant_ptr_vec <= grant_ptr_vec;
    end
end

wire [WIDTH_NUM-1:0] grant_ptr;
assign grant_ptr   = grant_ptr_vec[3] ? 3 :
                     grant_ptr_vec[2] ? 2 :
                     grant_ptr_vec[1] ? 1 :
                     grant_ptr_vec[0] ? 0 : 0;

reg [WIDTH_NUM-1:0] prio_ptr;
always @(posedge clk) begin
    if (!rst_n) begin
        prio_ptr <= 0;
    end else if (prio_ptr == 4) begin
        prio_ptr <= 0;
    end else if (num_packet == 1) begin
        prio_ptr <= grant_ptr;
    end else if (!s_last_i[prio_ptr]) begin
        prio_ptr <= prio_ptr;
    end else if (s_last_i[prio_ptr]) begin
        prio_ptr <= prio_ptr + 1;
    end
end

wire [NUM_REQUEST-1:0] grant_fixed_vec;
fixed_prio_arb  #(
    .NUM_REQUEST (NUM_REQUEST )
) u_fixed_prio_arb(
    .request_i (request_i >> prio_ptr),
    .grant_o   (grant_fixed_vec )
);

assign grant_o = grant_fixed_vec << prio_ptr;

    
endmodule