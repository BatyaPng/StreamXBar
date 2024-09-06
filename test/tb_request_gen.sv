module tb_request_gen();

parameter S_DATA_COUNT = 2;  // кол-во master устройств
parameter M_DATA_COUNT = 3;  // кол-во slave устройств

localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT);
logic clk;
logic rst_n;
logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0];
logic [T_DEST_WIDTH-1:0] num_slave;
logic [S_DATA_COUNT-1:0] req_o;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

request_gen #(
    .S_DATA_COUNT(S_DATA_COUNT),
    .M_DATA_COUNT(M_DATA_COUNT)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .s_dest_i(s_dest_i),
    .num_slave(num_slave),
    .req_o(req_o)
);

initial begin
    clk = 0;
    rst_n = 0;
    s_dest_i[0] = 0;
    s_dest_i[1] = 0;
    num_slave = 0;

    rst_n = 0;
    #10;
    rst_n = 1;

    // Тест 1: Нет конфликта, запрос к num_slave 0
    num_slave = 0;
    s_dest_i[0] = 0;
    s_dest_i[1] = 1;
    #10;
    $display("Тест 1 - num_slave = 0: req_o = %b", req_o);
    assert(req_o == 2'b01);  // Ожидаем, что только первый master отправит запрос

    // Тест 2: Запрос к num_slave 1 от обоих master
    num_slave = 1;
    s_dest_i[0] = 1;
    s_dest_i[1] = 1;
    #10;
    $display("Тест 2 - num_slave = 1: req_o = %b", req_o);
    assert(req_o == 2'b11);  // Ожидаем, что оба master отправят запросы

    // Тест 3: Запрос к num_slave 2, нет совпадающих master
    num_slave = 2;
    s_dest_i[0] = 0;
    s_dest_i[1] = 1;
    #10;
    $display("Тест 3 - num_slave = 2: req_o = %b", req_o);
    assert(req_o == 2'b00);  // Ожидаем, что никто не отправит запрос

    // Тест 4: Оба master запрашивают одного и того же slave
    num_slave = 1;
    s_dest_i[0] = 1;
    s_dest_i[1] = 1;
    #10;
    $display("Тест 4 - Оба master запрашивают num_slave = 1: req_o = %b", req_o);
    assert(req_o == 2'b11);  // Ожидаем запросы от обоих master

    $finish;
end

endmodule
