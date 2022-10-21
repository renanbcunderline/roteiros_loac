// Renan Chaves Bezerra -  121110071
// Roteiro 2

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

// IRRIGAÇÂO
 
	parameter apagado = 'b00000000;
	parameter zero = 'b00111111;
	parameter um = 'b00000110;
	parameter dois = 'b01011011;
	
	
	logic [1:0] areas;
	
	always_comb
		areas <= SWI[1:0];

	always_comb 
		unique case (areas)
			'b11 : SEG <= dois;
			'b01 : SEG <= um;
			'b10 : SEG <= zero;
			'b00 : SEG <= apagado;
		endcase
	
// ROTEAMENTO

	logic [1:0] a;
	logic [1:0] b;
	logic select;
	logic [1:0] saida;
	
	always_comb begin
		a <= SWI[7:6];
		b <= SWI[5:4];
		select <= SWI[3];
	end
	
	always_comb begin
		if (select == 0)
			saida <= a;
		else
			saida <= b;
	end
	
	always_comb
		LED[7:6] <= saida;
	
endmodule
