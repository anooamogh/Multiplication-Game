.text
.globl computer
# intialize registers with pointer values
computer:
	lw $t0, x
	lw $t1, y
	li $t2, 10
	
# increment pointer 1 by 1 
updating:	
	addi $t0, $t0, 1
	bgt $t2, $t0, calculate
	li $t0, 1
	
# calculate the product of pointers and get board address
calculate:
	mul $t3, $t0, $t1
	li $t4, 36
	li $t5, 0
	la $t6, board

# check if that value if available in the board
loop:	
	lw $t7, ($t6)
	beq $t7, $t3, found
	addi $t5, $t5, 1
	addi $t6, $t6, 4
	bne $t5, $t4, loop
	
	j updating		# was not available
	
found:
	sw $t0, x
	li $t8, 99		
	sw $t8, ($t6)		# store 99 in board to represent the computer
	jr $ra			# return to main
