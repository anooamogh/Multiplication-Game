.data
win:    .asciiz "Win!\n"            # String for winning message
lose:   .asciiz "Lose!\n"           # String for losing message
checkM:	.asciiz "Do you want to play another game? 1 to play again, 2 to exit "	
ptr1:	.asciiz "Pointer 1: "

.text
.globl main_check
#FIXME link to here where the program of mine begins
main_check:
addi $t5, $zero, 0               # Initialize loop counter for rows
addi $t6, $zero, 3               # Constant for the number of rows
addi $t7, $zero, 6               # Constant for the number of columns
add $t8, $zero, $zero            # Counter for matched sequences

la $t0, board                    # Load the base address of the board array

# Horizontal Check
loopH:
    addi $t5, $t5, 1              # Increment row counter
    
    # Load values from the current row
    lw $t1, 0($t0)               
    lw $t2, 4($t0)      
    lw $t3, 8($t0)      
    lw $t4, 12($t0)     
    
    # Check for four same values horizontally
    bne $t1, $t2, not_found_four_values
    bne $t1, $t3, not_found_four_values
    bne $t1, $t4, not_found_four_values
    bne $t2, $t3, not_found_four_values
    bne $t2, $t4, not_found_four_values
    bne $t3, $t4, not_found_four_values
    j found_a_match

not_found_four_values:
    beq $t5, $t6, next_row       # If four same values not found, go to the next row
    la $t0, 4($t0)               # Move to the next row in the array
    j loopH

next_row:
    addi $t8, $t8, 1              # Increment the matched sequences counter
    la $t0, 16($t0)               # Move to the next row in the array
    add $t5, $zero, $zero         # Reset row counter
    beq $t8, $t7, end_horizontal  # If all rows checked, exit the loop
    j loopH

end_horizontal: 
    # This is when there are no matches for the horizontal lines.

# Vertical Check
addi $t5, $zero, 0
addi $t6, $zero, 3
addi $t7, $zero, 6
add $t8, $zero, $zero
la $t0, board

loopV:
    addi $t5, $t5, 1
    
    # Load values from the current column
    lw $t1, 0($t0)               
    lw $t2, 24($t0)      
    lw $t3, 48($t0)      
    lw $t4, 72($t0)     
    
    # Check for four same values vertically
    bne $t1, $t2, not_found_four_values_V
    bne $t1, $t3, not_found_four_values_V
    bne $t1, $t4, not_found_four_values_V
    bne $t2, $t3, not_found_four_values_V
    bne $t2, $t4, not_found_four_values_V
    bne $t3, $t4, not_found_four_values_V
    j found_a_match

not_found_four_values_V:
    beq $t5, $t6, next_column     # If four same values not found, go to the next column
    la $t0, 24($t0)               # Move to the next column in the array
    j loopV

next_column:
    addi $t8, $t8, 1              # Increment the matched sequences counter
    la $t0, -44($t0)              # Move to the next column in the array
    add $t5, $zero, $zero         # Reset column counter
    beq $t8, $t7, end_vertical    # If all columns checked, exit the loop
    j loopV

end_vertical: 
    # This is when there are no matches for the vertical lines.

# Diagonal Right Check
addi $t5, $zero, 0
addi $t6, $zero, 3
addi $t7, $zero, 3
add $t8, $zero, $zero
la $t0, board

loopDR:
    addi $t5, $t5, 1
    
    # Load values from the current diagonal
    lw $t1, 0($t0)               
    lw $t2, 28($t0)      
    lw $t3, 56($t0)      
    lw $t4, 84($t0)     
    
    # Check for four same values diagonally (right)
    bne $t1, $t2, not_found_four_values_DR
    bne $t1, $t3, not_found_four_values_DR
    bne $t1, $t4, not_found_four_values_DR
    bne $t2, $t3, not_found_four_values_DR
    bne $t2, $t4, not_found_four_values_DR
    bne $t3, $t4, not_found_four_values_DR
    j found_a_match

not_found_four_values_DR:
    beq $t5, $t6, next_row_DR    # If four same values not found, go to the next row
    la $t0, 4($t0)               # Move to the next row in the array
    j loopDR

next_row_DR:
    addi $t8, $t8, 1              # Increment the matched sequences counter
    la $t0, 16($t0)               # Move to the next row in the array
    add $t5, $zero, $zero         # Reset row counter
    beq $t8, $t7, end_diagonal_DR # If all diagonals checked, exit the loop
    j loopDR

end_diagonal_DR: 

# Diagonal Left Check
addi $t5, $zero, 0
addi $t6, $zero, 3
addi $t7, $zero, 3
add $t8, $zero, $zero
la $t0, board
la $t0, 12($t0)

loopLR:
    addi $t5, $t5, 1
    
    # Load values from the current diagonal
    lw $t1, 0($t0)               
    lw $t2, 20($t0)      
    lw $t3, 40($t0)      
    lw $t4, 60($t0)     
    
    # Check for four same values diagonally (left)
    bne $t1, $t2, not_found_four_values_LR
    bne $t1, $t3, not_found_four_values_LR
    bne $t1, $t4, not_found_four_values_LR
    bne $t2, $t3, not_found_four_values_LR
    bne $t2, $t4, not_found_four_values_LR
    bne $t3, $t4, not_found_four_values_LR
    j found_a_match

not_found_four_values_LR:
    beq $t5, $t6, next_row_LR    # If four same values not found, go to the next row
    la $t0, 4($t0)               # Move to the next row in the array
    j loopLR

next_row_LR:
    addi $t8, $t8, 1              # Increment the matched sequences counter
    la $t0, 16($t0)               # Move to the next row in the array
    add $t5, $zero, $zero         # Reset row counter
    beq $t8, $t7, end_diagonal_LR # If all diagonals checked, exit the loop
    j loopLR

end_diagonal_LR: # The program has not found any winning combinations
	jr $ra

found_a_match:
    addi $t0, $zero, 00
    beq $t1, $t0, won_the_game
    li $v0, 4
    la $a0, lose
    syscall
    j check_if_another

won_the_game:
    li $v0, 4
    la $a0, win
    syscall
	
check_if_another:
	 li $v0, 4
	 la $a0, checkM
	 syscall
	 
	 li $v0, 5
	 syscall

	 li $t1, 1
	 beq $v0, $t1, play_again
	 
	 #exit
	 li $v0, 10
	 syscall
	 
play_again:
	jal reset_board

