`include "tt_um_ALU_NicolasOrcasitas.v"

module tt_um_ALU_NicolasOrcasitas_tb ();

    reg [7:0] in;
    wire [13:0] out;
    reg clk = 0;
    reg [2:0] ALUControl;
    reg [1:0] flagcontrol;
    reg enA;
    reg rst_n;

    wire flag;
    wire overflow;


    tt_um_ALU_NicolasOrcasitas UUT(
        .ui_in(in),
        .uo_out(out[7:0]),
        .uio_in({2'b00,flagcontrol,enA,ALUControl}),
        .uio_out({overflow, flag, out[13:8]}),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("tt_um_ALU_NicolasOrcasitas_tb.vcd");
        $dumpvars(0, tt_um_ALU_NicolasOrcasitas_tb);

        rst_n = 1'b0;
        #10;

        in = 8'd128;
        enA = 1'b1;
        #10;

        in = 8'd218;
        enA = 1'b0;
        #10;

        ALUControl = 3'b000;
        flagcontrol = 2'b00;
        #10;

        ALUControl = 3'b001;
        flagcontrol = 2'b01;
        #10;
        
        ALUControl = 3'b010;
        flagcontrol = 2'b10;
        #10;
        
        ALUControl = 3'b011;
        flagcontrol = 2'b11;
        #10;
        
        ALUControl = 3'b100;
        #10;
        
        ALUControl = 3'b101;
        #10;
        
        ALUControl = 3'b110;
        #10;
        
        ALUControl = 3'b111;
        #10;
        $finish();

    end
    
endmodule