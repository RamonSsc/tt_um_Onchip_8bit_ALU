module tt_um_ALU_Porca (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

reg [3:0] A, B;
reg flag, overflow;
reg [7:0] out;

wire [2:0] ALUcontrol;
wire enReg;
wire [2:0] flagcontrol;

assign uio_oe = 8'b10000000;

assign ALUcontrol = uio_in[2:0];
assign enReg = uio_in[3];
assign flagcontrol = uio_in[6:4];

assign uio_out[6:0] = 7'd0; // No se usan los bits 0-6 de uio_out, se asignan a 0
assign uio_out[7] = flag;
//assign uio_out[7] = overflow;


assign uo_out = out;

// Input registers

// register A
always @(posedge clk) begin
    if (!rst_n) begin
        A <= 4'd0;
    end    
    else if (enReg) begin
        A <= ui_in[3:0];
    end
end
// Resgistrer B
always @(posedge clk) begin
    if (!rst_n) begin
        B <= 4'd0;
    end    
    else if (enReg) begin
        B <= ui_in[7:4];
    end
end

// ALU control
always @(*) begin
    case (ALUcontrol)
        3'b000: {out[7:0]} = A + B;                 // Adition
        3'b001: {out[7:0]} = A - B;                 // Substraction
        3'b010: {out[7:0]} = {5'b00000, A[3:1]};           // Shift right
        3'b011: {out[7:0]} = {3'b000, A[3:0], 1'b0};           // Shift left
        3'b100: {out[7:0]} = {4'b0000, (A & B)};                 // AND
        3'b101: {out[7:0]} = {4'b0000, (A | B)};                 // OR
        3'b110: {out[7:0]} = {4'b0000, (A ^ B)};                 //XOR
        3'b111: {out[7:0]} = A * B;                       //Mult
        default: {out[7:0]} = 8'd0;
    endcase
end


// Flag Control
always @(*) begin
    case (flagcontrol)
        3'b000: flag = A > B;        // Greater than 
        3'b001: flag = A == B;       // Equal
        3'b010: flag = A == 4'd0;    // A Equal zero
        3'b011: flag = A[0] == 0;    // Check even
        3'b100: flag = B > A;        // B Greater than A
        3'b101: flag = A == B;       // Equal
        3'b110: flag = B == 4'd0;    // B Equal zero
        3'b111: flag = B[0] == 0;    // Check even
        default: flag = 3'd0;
    endcase
end
/*
// Overflow
always @(*) begin
    if(uio_out[5:0] == 6'd0) begin
        overflow <= 0;
    end       
    else begin
        overflow <= 1;
    end
end
*/
    // List all unused inputs to prevent warnings
    wire _unused = &{ena, uio_in[7], 1'b0};
endmodule