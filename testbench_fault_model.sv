`timescale 1ns / 1ps

module testbench_fault_model;

    reg clk = 0;
    reg reset = 1;
    reg enable = 0;
    reg [15:0] data_in;
    reg [15:0] fault_mask;
    reg [15:0] fault_value;
    wire [15:0] crc_out;

    integer csv;

    // Instantiate DUT
    crc16_fault uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .fault_mask(fault_mask),
        .fault_value(fault_value),
        .crc_out(crc_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench_fault_model);

        csv = $fopen("crc_fault_output.csv", "w");
        $fwrite(csv, "Time_ns,Data_in,FaultMask,FaultValue,CRC_out\n");

        #10 reset = 0;

        // Test 1: No faults
        apply(16'hABCD, 16'h0000, 16'h0000);

        // Test 2: Bit 3 stuck-at-0
        apply(16'h1234, 16'h0008, 16'h0000);

        // Test 3: Bit 5 stuck-at-1
        apply(16'h0000, 16'h0020, 16'h0020);

        // Test 4: All bits stuck-at-1
        apply(16'hFFFF, 16'hFFFF, 16'hFFFF);

        // Test 5: Random value, bit 15 stuck-at-0
        apply(16'h8000, 16'h8000, 16'h0000);

        #50 $fclose(csv);
        #10 $finish;
    end

    task apply(input [15:0] data, input [15:0] mask, input [15:0] stuck_value);
        begin
            @(negedge clk);
            data_in = data;
            fault_mask = mask;
            fault_value = stuck_value;
            enable = 1;
            @(negedge clk);
            enable = 0;
        end
    endtask

    // Write output to CSV on every rising edge of clk if enabled
    always @(posedge clk) begin
        if (enable) begin
            $fwrite(csv, "%0t,%h,%h,%h,%h\n", $time, data_in, fault_mask, fault_value, crc_out);
        end
    end

endmodule

