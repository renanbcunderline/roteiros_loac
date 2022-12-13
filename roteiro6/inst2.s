addi, x10, x0, 2
addi, x11, x0, 4
beq, x10, x11, b
add, x12, x10, x10
jal, x0, j
b: add, x12, x11, x11
j: addi x0, x0, 0