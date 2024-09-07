module request_gen_tb;

    // Параметры
    parameter S_DATA_COUNT = 2;
    parameter M_DATA_COUNT = 3;
    localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT);

    // Входные сигналы
    reg [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0];
    reg [S_DATA_COUNT-1:0] s_valid_i;

    // Выходные сигналы
    wire [S_DATA_COUNT-1:0] req_o [M_DATA_COUNT-1:0];

    // Модуль для тестирования
    request_gen #(
        .S_DATA_COUNT(S_DATA_COUNT),
        .M_DATA_COUNT(M_DATA_COUNT)
    ) uut (
        .s_dest_i(s_dest_i),
        .s_valid_i(s_valid_i),
        .req_o(req_o)
    );

    // Процесс тестирования
    initial begin
        // Инициализация сигналов
        s_dest_i[0] = 0;
        s_dest_i[1] = 1;
        s_valid_i = 2'b00;
        
        #10; // Подождем 10 тиков

        // Тест 1: оба master устройства не активны
        $display("Test 1: s_valid_i = %b", s_valid_i);
        #10;
        $display("req_o = %b %b %b", req_o[0], req_o[1], req_o[2]);

        // Тест 2: только первый master активен и отправляет запрос к slave 0
        s_valid_i = 2'b01;
        s_dest_i[0] = 0;  // master 0 направлен к slave 0
        #10;
        $display("Test 2: s_valid_i = %b, s_dest_i[0] = %d", s_valid_i, s_dest_i[0]);
        $display("req_o = %b %b %b", req_o[0], req_o[1], req_o[2]);

        // Тест 3: оба master активны и направлены к разным slave
        s_valid_i = 2'b11;
        s_dest_i[0] = 0;  // master 0 направлен к slave 0
        s_dest_i[1] = 2;  // master 1 направлен к slave 2
        #10;
        $display("Test 3: s_valid_i = %b, s_dest_i[0] = %d, s_dest_i[1] = %d", s_valid_i, s_dest_i[0], s_dest_i[1]);
        $display("req_o = %b %b %b", req_o[0], req_o[1], req_o[2]);

        // Тест 4: оба master активны и направлены к одному и тому же slave
        s_dest_i[0] = 1;  // master 0 направлен к slave 1
        s_dest_i[1] = 1;  // master 1 направлен к slave 1
        #10;
        $display("Test 4: s_valid_i = %b, s_dest_i[0] = %d, s_dest_i[1] = %d", s_valid_i, s_dest_i[0], s_dest_i[1]);
        $display("req_o = %b %b %b", req_o[0], req_o[1], req_o[2]);

        // Остановка симуляции
        $finish;
    end
endmodule
