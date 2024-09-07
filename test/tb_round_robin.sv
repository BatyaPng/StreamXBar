module tb_round_robin;
// Параметры
localparam NUM_REQUEST = 4;
localparam MAX_PACKETS = 8;

// Локальные переменные
reg clk;
reg rst_n;
reg [NUM_REQUEST-1:0] request_i;
reg [NUM_REQUEST-1:0] s_last_i;
wire [NUM_REQUEST-1:0] grant_o;

// Ожидаемое значение
reg [NUM_REQUEST-1:0] expected_grant_o;

// Инстанс тестируемого модуля
round_robin #(
    .NUM_REQUEST(NUM_REQUEST),
    .MAX_PACKETS(MAX_PACKETS)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .request_i(request_i),
    .s_last_i(s_last_i),
    .grant_o(grant_o)
);

// Генератор тактового сигнала
always #1 clk = ~clk;

initial begin
    $dumpvars;
    // Инициализация сигналов
    clk = 0;
    rst_n = 1;
    request_i = 4'b0000;
    s_last_i = 4'b0000;
    expected_grant_o = 4'b0000;

    // Сброс системы
    #2;
    rst_n = 0;

    // Тест 1: запрос только от первого устройства и третьего устройства
    #3;
    request_i = 4'b0101;
    expected_grant_o = 4'b0001;
    #5;
    $display ("Test 1: Expected %b, got %b", expected_grant_o, grant_o);

    // Тест 2: первое устройсто завершило работу
    #1;
    s_last_i = 4'b0001;
    request_i = 4'b0100;
    expected_grant_o = 4'b0100; // Приоритет третьего устройства
    #5;
    $display ("Test 2: Expected %b, got %b", expected_grant_o, grant_o);

    // Тест 3: третье устройсто завершило работу, запрос от второго и четвёртого
    #1;
    s_last_i = 4'b0100;
    request_i = 4'b1010;
    expected_grant_o = 4'b1000; // Приоритет второго устройства
    #5;
    $display ("Test 3: Expected %b, got %b", expected_grant_o, grant_o);


    // Тест 4: четвёртон устройсто завершило работу, запрос от второго
    #1;
    s_last_i = 4'b1000;
    request_i = 4'b1010;
    expected_grant_o = 4'b0010; // Приоритет второго устройства
    #1;
    request_i = 4'b0010;
    #5;
    $display ("Test 4: Expected %b, got %b", expected_grant_o, grant_o);
    
    $display("All tests passed!");
    $finish;
end
endmodule
