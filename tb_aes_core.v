`timescale 1ns/1ps

module tb_aes_core();
  reg clk = 0;
  reg reset_n = 0;
  reg encdec;
  reg init;
  reg next;
  wire ready;
  reg [255:0] key;
  reg keylen;
  reg [127:0] block;
  wire [127:0] result;
  wire result_valid;

  // Instantiate the AES core
  aes_core dut (
    .clk(clk),
    .reset_n(reset_n),
    .encdec(encdec),
    .init(init),
    .next(next),
    .ready(ready),
    .key(key),
    .keylen(keylen),
    .block(block),
    .result(result),
    .result_valid(result_valid)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Dump waves so you can view them in GTKWave if needed
    $dumpfile("tb_aes_core.vcd");
    $dumpvars(0, tb_aes_core);

    // Initialize inputs
    init = 0; next = 0; encdec = 1; keylen = 0; // 0 = AES-128
    key = 256'h0; block = 128'h0;

    // Reset the system
    #20 reset_n = 1;

    $display("=================================================");
    $display("          AES CORE SIMULATION START              ");
    $display("=================================================");

    // ---------------------------------------------------------
    // TEST 1: AES-128 ENCRYPTION
    // ---------------------------------------------------------
    encdec = 1; // 1 = Encrypt
    keylen = 0; // 0 = 128-bit key
    
    // Note: Your AES core expects the 128-bit key in the UPPER 128 bits of the 256-bit wire
    key = {128'h2b7e151628aed2a6abf7158809cf4f3c, 128'h0}; 
    block = 128'h3243f6a8885a308d313198a2e0370734;

    $display("\n--- ENCRYPTION TEST ---");
    $display("Plaintext : %x", block);
    $display("Key       : %x", key[255:128]);

    // Send INIT pulse to load the key
    @(negedge clk) init = 1;
    @(negedge clk) init = 0;
    wait(ready == 1'b1); // Wait for key expansion to finish

    // Send NEXT pulse to encrypt the block
    @(negedge clk) next = 1;
    @(negedge clk) next = 0;
    wait(result_valid == 1'b1); // Wait for encryption to finish
    
    $display("Ciphertext: %x", result);
    // FIXED: Now expecting the correct NIST ciphertext
    if (result === 128'h3925841d02dc09fbdc118597196a0b32) 
        $display("Result    : [PASS]");
    else 
        $display("Result    : [FAIL]");
    wait(ready == 1'b1);

    // ---------------------------------------------------------
    // TEST 2: AES-128 DECRYPTION
    // ---------------------------------------------------------
    encdec = 0; // 0 = Decrypt
    
    // FIXED: Using the newly corrected ciphertext as input for decryption
    block = 128'h3925841d02dc09fbdc118597196a0b32;

    $display("\n--- DECRYPTION TEST ---");
    $display("Ciphertext: %x", block);
    $display("Key       : %x", key[255:128]);

    // Send INIT pulse to load the key
    @(negedge clk) init = 1;
    @(negedge clk) init = 0;
    wait(ready == 1'b1); 

    // Send NEXT pulse to decrypt the block
    @(negedge clk) next = 1;
    @(negedge clk) next = 0;
    wait(result_valid == 1'b1);
    
    $display("Plaintext : %x", result);
    if (result === 128'h3243f6a8885a308d313198a2e0370734) 
        $display("Result    : [PASS]");
    else 
        $display("Result    : [FAIL]");
    
    $display("\n=================================================");
    $display("               SIMULATION FINISHED               ");
    $display("=================================================");
    #50 $finish;
  end
endmodule
