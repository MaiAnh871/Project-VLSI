module carry_lookahead_adder
    #(parameter WIDTH)
    (
        input                   clk,
        input                   reset_n,
        input [WIDTH-1:0]       addend_0,
        input [WIDTH-1:0]       addend_1,
        output reg [WIDTH:0]    sum
    );
        
    wire [WIDTH:0]     w_C;
    wire [WIDTH-1:0]   w_G, w_P, w_SUM;
    
    // Create the Full Adders
    genvar             i;
    generate
        for (i=0; i<WIDTH; i=i+1) 
        begin
            full_adder FA
                ( 
                .i_bit1(addend_0[i]),
                .i_bit2(addend_1[i]),
                .i_carry(w_C[i]),
                .o_sum(w_SUM[i]),
                .o_carry()
                );
        end
    endgenerate
    
    // Create the Generate (G) Terms:  Gi=Ai*Bi
    // Create the Propagate Terms: Pi=Ai+Bi
    // Create the Carry Terms:
    genvar             j;
    generate
        for (j=0; j<WIDTH; j=j+1) 
        begin
            assign w_G[j]   = addend_0[j] & addend_1[j];
            assign w_P[j]   = addend_0[j] | addend_1[j];
            assign w_C[j+1] = w_G[j] | (w_P[j] & w_C[j]);
        end
    endgenerate
    
    assign w_C[0] = 1'b0; // No carry input
    
    always @ (posedge clk or negedge reset_n)
        begin
                if (~reset_n) begin
                    sum <= 0;
                end
                else begin
                    sum <= {w_C[WIDTH], w_SUM};
                end
        
        end
    
endmodule