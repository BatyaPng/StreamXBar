module tb_com();

  // Параметры
  parameter T_DATA_WIDTH = 8;
  parameter S_DATA_COUNT = 2;
  parameter M_DATA_COUNT = 3;
  parameter T_ID_M_WIDTH = $clog2(S_DATA_COUNT);
  parameter T_DEST_WIDTH = $clog2(M_DATA_COUNT);

  // Входы
  reg [T_DATA_WIDTH-1:0] s_data_i        [S_DATA_COUNT-1:0];
  reg [T_DEST_WIDTH-1:0] s_dest_noconf_i [S_DATA_COUNT-1:0];
  reg [S_DATA_COUNT-1:0] req_i           [M_DATA_COUNT-1:0];
  reg [S_DATA_COUNT-1:0] s_last_i;
  reg [S_DATA_COUNT-1:0] s_valid_i;
  reg [M_DATA_COUNT-1:0] m_ready_i;

  // Выходы
  wire [T_DATA_WIDTH-1:0] m_data_o  [M_DATA_COUNT-1:0];
  wire [T_ID_M_WIDTH-1:0] m_id_o    [M_DATA_COUNT-1:0];
  wire [M_DATA_COUNT-1:0] m_last_o;
  wire [M_DATA_COUNT-1:0] m_valid_o;

  // Экземпляр тестируемого модуля
  com #(
    .T_DATA_WIDTH(T_DATA_WIDTH),
    .S_DATA_COUNT(S_DATA_COUNT),
    .M_DATA_COUNT(M_DATA_COUNT)
  ) dut (
    .s_data_i(s_data_i),
    .req_i(req_i),
    .s_last_i(s_last_i),
    .s_valid_i(s_valid_i),
    .m_data_o(m_data_o),
    .m_id_o(m_id_o),
    .m_last_o(m_last_o),
    .m_valid_o(m_valid_o),
    .m_ready_i(m_ready_i)
  );

  // Процедура вывода ожиданий и фактических данных
  task check_output;
    input int slave_index;
    input [T_DATA_WIDTH-1:0] expected_data;
    input [T_ID_M_WIDTH-1:0] expected_id;
    input expected_last;
    input expected_valid;

    begin
      $display("Ожидается на Slave %0d: data=%h, id=%h, last=%b, valid=%b", 
               slave_index, expected_data, expected_id, expected_last, expected_valid);
      $display("Фактически на Slave %0d: data=%h, id=%h, last=%b, valid=%b", 
               slave_index, m_data_o[slave_index], m_id_o[slave_index], m_last_o[slave_index], m_valid_o[slave_index]);

      if (m_data_o[slave_index] !== expected_data || 
          m_id_o[slave_index] !== expected_id || 
          m_last_o[slave_index] !== expected_last || 
          m_valid_o[slave_index] !== expected_valid) begin
        $display("Тест не пройден для Slave %0d!", slave_index);
      end else begin
        $display("Тест пройден для Slave %0d!", slave_index);
      end
      $display("------------------------------------------------");
    end
  endtask

  // Начальные условия
  initial begin
    $dumpvars;
    // Инициализация сигналов
    for (int i = 0; i < S_DATA_COUNT; i++) begin
      s_data_i[i] = 0;
      s_last_i[i] = 0;
      s_valid_i[i] = 0;
    end

    // Назначаем каждому мастеру свой уникальный слейв для передачи данных
    req_i[0][0] = 1;
    req_i[0][1] = 0; // Master 0 нацелен на Slave 0
    req_i[1][1] = 1;
    req_i[1][0] = 0; // Master 1 нацелен на Slave 1

    for (int i = 0; i < M_DATA_COUNT; i++) begin
      m_ready_i[i] = 1;
    end

    #10;

    // Тест 1: Master 1 отправляет три пакета на Slave 1, последний пакет с флагом s_last_i = 1
    s_data_i[1] = 8'h5A;
    s_valid_i[1] = 1;
    s_last_i[1] = 0;
    m_ready_i[1] = 1;

    #10;

    // Проверка данных на Slave 1 (первый пакет)
    check_output(1, 8'h5A, 1, 0, 1);

    // Второй пакет
    s_data_i[1] = 8'h6B;

    #10;

    // Проверка данных на Slave 1 (второй пакет)
    check_output(1, 8'h6B, 1, 0, 1);

    // Третий пакет (последний)
    s_data_i[1] = 8'h7C;
    s_last_i[1] = 1;

    #10;

    // Проверка данных на Slave 1 (последний пакет)
    check_output(1, 8'h7C, 1, 1, 1);

    // Завершение симуляции
    $finish;
  end

endmodule
