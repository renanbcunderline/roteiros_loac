// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  // CONTADOR HEXADECIMAL
  
  parameter zero = 'b00111111;
  parameter um = 'b00000110;
  parameter dois = 'b01011011;
  parameter tres = 'b01001111;
  parameter quatro = 'b00110011;
  parameter cinco = 'b01011011;
  parameter seis = 'b01011111;
  parameter sete = 'b0111000;
  parameter oito = 'b01111110;
  parameter nove = 'b0111000;
  parameter a = 'b01110111;
  parameter b = 'b00011111;
  parameter c = 'b01001110;
  parameter d = 'b00111101;
  parameter e = 'b01001111;
  parameter f = 'b01000111; 
  
  parameter NBITS_COUNT = 4;
  logic [NBITS_COUNT-1 : 0] Data_in, Count;
  logic reset, load, count_up;
  
  always_comb begin
  	reset <= SWI[0];
  	count_up <= SWI[1];
  	load <= SWI[2];
  	Data_in <= SWI[7 : 4];
  end
  
  always_ff @ (posedge reset or posedge clk_2) begin
  	if (reset)
  		Count <= 0;
  		
  	else if (load)
  		Count <= Data_in;
  		
  	else begin
  		if (count_up)
  			Count <= Count + 1;
  		else
  			Count <= Count - 1;
  	end
  end
  
  always_comb begin
  	LED[0] <= clk_2;
  	LED[1] <= count_up;
  	LED[7 : 4] <= Count;
  end
  
  always_comb begin
		case (Count)
			4'b0000 : SEG <= zero;
			4'b0001 : SEG <= um;
			4'b0010 : SEG <= dois;
			4'b0011 : SEG <= tres;
			4'b0100 : SEG <= quatro;
			4'b0101 : SEG <= cinco;
			4'b0110 : SEG <= seis;
			4'b0111 : SEG <= sete;
			4'b1000 : SEG <= oito;
			4'b1001 : SEG <= nove;
			4'b1010 : SEG <= a;
			4'b1011 : SEG <= b;
			4'b1100 : SEG <= c;
			4'b1101 : SEG <= d;
			4'b1110 : SEG <= e;
			4'b1111 : SEG <= f;
			
		endcase
	end
  
endmodule
