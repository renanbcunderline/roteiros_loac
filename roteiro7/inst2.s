.text
li x11, 0xFE		# salva o registrador x11 o valor do dado

li, x12, 0x000		# salva no registrador x12 a parte menos significativa (12 bits) do endereço de memória
lui x12, 0x10000	# salva no registrador x12 a parte mais significativa (20 bits)  do endereço de memória

sw x11, 0xC(x12)	# carrega o valor do registrador x11 para o endereço de memória contida no registrador x12 acrescidos de 0xC
lw x10, 0xC(x12)	# salva no registrador x10 o valor do dado da memória contida no registrador x12 acrescidos de 0xC 
