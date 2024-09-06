module tb_conflict_finder;

parameter S_DATA_COUNT = 2;
parameter M_DATA_COUNT = 3;
localparam T_DEST_WIDTH = $clog2(M_DATA_COUNT);

logic clk;
logic rst_n;
logic [T_DEST_WIDTH-1:0] s_dest_i [S_DATA_COUNT-1:0];
logic [M_DATA_COUNT-1:0] conflict_o;

conflict_finder #(
    .S_DATA_COUNT(S_DATA_COUNT),
    .M_DATA_COUNT(M_DATA_COUNT)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .s_dest_i(s_dest_i),
    .conflict_o(conflict_o)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    s_dest_i[0] = 0;
    s_dest_i[1] = 0;
    #10;
    
    rst_n = 1;

    // Тест 1: Нет конфликта, разные назначения
    s_dest_i[0] = 0;
    s_dest_i[1] = 1;
    #10;
    $display("Test 1: No conflict");
    display_outputs();
    

    // Тест 2: Конфликт, оба master нацелены на один и тот же slave
    s_dest_i[0] = 1;
    s_dest_i[1] = 1;
    #10;
    $display("Test 2: Conflict detected");
    display_outputs();

    // Тест 3: Нет конфликта, разные назначения
    s_dest_i[0] = 2;
    s_dest_i[1] = 1;
    #10;
    $display("Test 3: No conflict");
    display_outputs();

    // Тест 4: Конфликт, оба master нацелены на один и тот же slave
    s_dest_i[0] = 2;
    s_dest_i[1] = 2;
    #10;
    $display("Test 4: Conflict detected");
    display_outputs();

    // Тест 5: Конфликт, оба master нацелены на один и тот же slave
    s_dest_i[0] = 0;
    s_dest_i[1] = 0;
    #10;
    $display("Test 5: Conflict detected");
    display_outputs();

    $finish;
end

task display_outputs;
    $display("conflict_o = %b", conflict_o);
endtask

endmodule
