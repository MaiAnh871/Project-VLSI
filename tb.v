module tb ();
 
    parameter WIDTH = 9;
    
    reg             r_CLK = 0;
    reg             r_RESET_N;
    reg [WIDTH-1:0] r_ADDEND_0 = 0;
    reg [WIDTH-1:0] r_ADDEND_1 = 0;
    wire [WIDTH:0]  w_SUM;
    reg [WIDTH:0]  w_SUM_test = 0;
    
    carry_lookahead_adder #(.WIDTH(WIDTH)) CLA
        (
            .clk(r_CLK),
            .reset_n(r_RESET_N),
            .addend_0(r_ADDEND_0),
            .addend_1(r_ADDEND_1),
            .sum(w_SUM)
        );
    
    // Testbench variable
    integer number_of_test = 0;
    integer number_of_success = 0;
    integer number_of_failure = 0;
    integer file;
    integer i;
    integer nCase = 10; // Number of test case

    // Clock signal
    initial begin
        forever #10 r_CLK = ~r_CLK; // for simulation
    end

    initial begin
         
    // Read test file
    file = $fopen("test_case.txt","r");

    r_RESET_N = 0;
    #50; 
    // Reset for 200 clock cycle
    r_RESET_N = 1;
    #50;

    $display("Tables Known Answer Tests");
    $display("-------------------------");

    for (i = 0; i < nCase; i = i + 1)
    begin
        @(posedge r_CLK);
        #3;
        number_of_test = number_of_test + 1;
        $fscanf(file, "%d", r_ADDEND_0);
        $fscanf(file, "%d", r_ADDEND_1);

        @(posedge r_CLK);
        #1;
        $fscanf(file, "%d", w_SUM_test);

        $display("Test Vector Number: %d", number_of_test);
        $display("Result: %d", w_SUM);
        
        if(w_SUM == w_SUM_test) begin
            $display("OK");
            number_of_success = number_of_success + 1;
        end
        else begin
            $display("ERROR");
            number_of_failure = number_of_failure + 1;
        end

    end

    $fclose(file);

    $display("=============== Summary ===========================");
    $display("Number of inputs: %d", number_of_test);
    $display("Number of test passed: %d", number_of_success);
    $display("Number of test failed: %d", number_of_failure);
    $display("===================================================");

    $finish;
 
    end
endmodule