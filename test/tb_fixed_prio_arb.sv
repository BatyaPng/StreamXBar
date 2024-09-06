module tb_fixed_prio_arb;

parameter NUM_REQUEST = 4;

logic [NUM_REQUEST-1:0] request_i;
logic [NUM_REQUEST-1:0] grant_o;

fixed_prio_arb #(
  .NUM_REQUEST(NUM_REQUEST)
) uut (
  .request_i(request_i),
  .grant_o(grant_o)
);

  // Процесс тестирования
initial begin
    // Ожидание сброса симуляции
    $display("Start of test");

    // Тест 1: Проверка приоритетного запроса
    request_i = 4'b0001; // Активен только первый запрос
    #10;
    assert(grant_o == 4'b0001) else $error("Test 1 failed: grant_o = %b", grant_o);

    // Тест 2: Второй запрос активен
    request_i = 4'b0010; // Активен только второй запрос
    #10;
    assert(grant_o == 4'b0010) else $error("Test 2 failed: grant_o = %b", grant_o);

    // Тест 3: Активен несколько запросов одновременно
    request_i = 4'b0110; // Активны второй и третий запросы
    #10;
    assert(grant_o == 4'b0010) else $error("Test 3 failed: grant_o = %b", grant_o);

    // Тест 4: Все запросы активны
    request_i = 4'b1111; // Все запросы активны
    #10;
    assert(grant_o == 4'b0001) else $error("Test 4 failed: grant_o = %b", grant_o);

    // Тест 5: Нет активных запросов
    request_i = 4'b0000; // Нет активных запросов
    #10;
    assert(grant_o == 4'b0000) else $error("Test 5 failed: grant_o = %b", grant_o);

    $display("End of test");
    $finish;
end

endmodule
