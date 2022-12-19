.text
addi x12, x0, 1
addi x10, x0, 3
i: blt x10, x0, n
beq x10, x0, z
mul x12, x12, x10
addi x10, x10, -1
jal i

z: addi  a0, x0, 1               
add    a1, x0, x12
ecall
jal fim

n: addi  a0, x0, 4               
la    a1, negativo 
ecall

fim: nop

.data                  
negativo:  .asciiz "Fatorial inexistente\n"
