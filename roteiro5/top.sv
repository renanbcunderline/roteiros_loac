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
  parameter quatro = 'b01100110;
  parameter cinco = 'b1101101;
  parameter seis = 'b01111101;
  parameter sete = 'b00000111;
  parameter oito = 'b01111111;
  parameter nove = 'b01100111;
  parameter a = 'b01110111;
  parameter b = 'b01111100;
  parameter c = 'b00111001;
  parameter d = 'b01011110;
  parameter e = 'b01111001;
  parameter f = 'b01110001; 
  
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
  			Count <= Count - 1;
  		else
  			Count <= Count + 1;
  	end
  end
  
  always_comb begin
  	LED[7] <= clk_2;
  	LED[1] <= count_up;
  end
  
  always_comb begin
		case (Count)
			'b0000 : SEG <= zero;
			'b0001 : SEG <= um;
			'b0010 : SEG <= dois;
			'b0011 : SEG <= tres;
			'b0100 : SEG <= quatro;
			'b0101 : SEG <= cinco;
			'b0110 : SEG <= seis;
			'b0111 : SEG <= sete;
			'b1000 : SEG <= oito;
			'b1001 : SEG <= nove;
			'b1010 : SEG <= a;
			'b1011 : SEG <= b;
			'b1100 : SEG <= c;
			'b1101 : SEG <= d;
			'b1110 : SEG <= e;
			'b1111 : SEG <= f;
			
		endcase
	end
	
	//	DETECTOR DE SEQUENCIA
	
	logic in_bit, out_bit;
	
	always_comb in_bit <= SWI[3];
	
	enum logic [3 : 0] {A, B, C, D} state;
	
	always_ff @ (posedge clk_2) begin
		if (reset) state <= A;
		
		else 
			unique case (state)
				A:
					if (in_bit == 0)
						state <= A;
					else
						state <= B;
						
				B:
					if (in_bit == 0)
						state <= A;
					else
						state <= C;
						
				C:
					if (in_bit <= 0)
						state <= A;
					else
						state <= D;
						
				D:
					if (in_bit <= 0)
						state <= A;
					else
						state <= D;
			endcase
	
	end
	
	always_comb out_bit <= (state == D);
	always_comb LED[0] <= out_bit;
  
endmodule
