.data
x:	.word	1
y:	.word	1
ptr:	.word 	0
input:	.word	0
board:	.word	1, 2, 3, 4, 5, 6
	.word	7, 8, 9, 10, 12, 14
	.word	15, 16, 18, 20, 21, 24
	.word	25, 27, 28, 30, 32, 35
	.word	36, 40, 42, 45, 48, 49
	.word	54, 56, 63, 64, 72, 81
default:.word 	1, 2, 3, 4, 5, 6
	.word 	7, 8, 9, 10, 12, 14
	.word 	15, 16, 18, 20, 21, 24
	.word 	25, 27, 28, 30, 32, 35
	.word 	36, 40, 42, 45, 48, 49
	.word 	54, 56, 63, 64, 72, 81
which:	.asciiz "\nWhich pointer would you like to move? "
ptr1:	.asciiz "Pointer 1: "
ptr2: 	.asciiz "\nPointer 2: "
prompt:	.asciiz	"Enter an integer 1-9: "
error: .asciiz	"This number does not work\n"

.text
.globl board
.globl main
.globl x
.globl y
.globl reset_board

main:
# display the board to the user
jal display

# display the current pointers and update them
moving:
	li $v0, 4
	la $a0, ptr1		# display the first pointer
	syscall
	
	li $v0, 1
	lw $a0, x		# display the value of the pointer
	syscall
	
	li $v0, 4
	la $a0, ptr2		# display the next pointer
	syscall
	
	li $v0, 1
	lw $a0, y		# display the value of the next pointer
	syscall

	li $v0, 4
	la $a0, which		# ask user which they would like to move
	syscall
	
	li $v0, 5		# read in integer
	syscall
	
	sw $v0, ptr
	lw $t1, ptr
	li $t2, 3
	blez $t1, moving		# if 0 or smaller, ask for input again
	bge $t1, $t2, moving	# if greater than 3, ask for input again
	j get_input

# the new value is not within range
wrong_input:
	li $v0, 4
	la $a0, error		# display the error message
	syscall
# get the new number the pointer holds
get_input:
	li $v0, 4
	la $a0, prompt		# prompt for an integer
	syscall
	
	li $v0, 5		# read in integer
	syscall

	sw $v0, input		# save integer
	
	li $t2, 9
	lw $t3, input			
	blez $t3, wrong_input		# numbers 0 or lower don't work
	bgt $t3, $t2, wrong_input	# number greater than 9 do not work
	
	li $t0, 2
	lw $t1, ptr
	beq $t0, $t1, ptr_2		# if the number entered was 2
	
	lw $t0, input			# load input into $t0
	lw $t1, y			# load y in $t1
	j calculating
	
ptr_2:
	lw $t0, x			# load x in $t0
	lw $t1, input			# load input in $t1

# get the product of the pointers and check if it is in the board
calculating:	
	mul $t2, $t0, $t1	# multiply the pointer values
	li $t5, 36		# the max size of the board 
	li $t3, 0		# the counter for the loop
	la $t4, board		# address of the board
	
loop:
	lw $t6, ($t4)
	beq $t2, $t6, found	# the calculated number was in the board still
	addi $t3, $t3, 1		# update the counter for the loop
	addi $t4, $t4, 4		# move to next spot in board
	bne $t3, $t5, loop	# if the loop isn't finished, loop again
	
	li $v0, 4
	la $a0, error		# display the error message
	syscall
	
	j moving			# get new input from the user
	
found:
	li $t6, 0
	sw $t6, ($t4)		# replace the value in the array with 0 
	sw $t0, x
	sw $t1, y
	
	jal main_check		# check if the user won
	jal computer		# jump to the part the computer does
	jal main_check		# check if the computer won
	j main			# jump back to the beginning because no one won

# restarting the game
reset_board:
	la $t0, board		# reload the board address
	la $t1, default		# load the address of the default values

	li $t2, 0 		# initialize loop counter for copying

reset_loop:
	lw $t3, 0($t1)		# load default value
        sw $t3, 0($t0)		# store into the board

        addi $t0, $t0, 4 	# move to next number in board
        addi $t1, $t1, 4		# move to next default number
        addi $t2, $t2, 1  	# update counter

        blt $t2, 36, reset_loop	
        li $t4, 1		
       	sw $t4, x		# reset pointer 1
       	sw $t4, y		# reset pointer 2

        j main			# jump back to the start

# closes the entire program
end:
	li $v0, 10 		
	syscall 
