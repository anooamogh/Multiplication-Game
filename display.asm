.data
    row_len: .word 6

.text
.globl display
display:
    # Initialize registers
    la $t0, board    # Load the base address of the pattern array
    lw $t1, row_len    # Load the number of columns
    li $t2, 6          # Number of rows

loop:
    beq $t2, $zero, done  # Exit loop if we have printed all rows
    move $t3, $t1

    # Print starting '|'
    li $v0, 11
    li $a0, 124
    syscall

    inner_loop:
    lw $t4, 0($t0)    # Load the current element

    # Check if the number is less than 10
    blt $t4, 10, print_leading_zero

    # Print leading space for alignment
    li $v0, 11
    li $a0, 32
    syscall

    # Print integer
    li $v0, 1
    move $a0, $t4
    syscall
    
    # Print trailing space for equal spacing
    li $v0, 11
    li $a0, 32
    syscall

    # Print separator
    li $v0, 11
    li $a0, 124
    syscall

    # Print trailing space for equal spacing
    li $v0, 11
    li $a0, 32
    syscall

    j continue_inner_loop

print_leading_zero:
    # Print trailing space for equal spacing
    li $v0, 11
    li $a0, 32
    syscall

    # Print leading zero
    li $v0, 1
    li $a0, 0   # ASCII code for '0'
    syscall

    # Print integer
    li $v0, 1
    move $a0, $t4
    syscall
    
    # Print trailing space for equal spacing
    li $v0, 11
    li $a0, 32
    syscall

    # Print separator
    li $v0, 11
    li $a0, 124
    syscall

    # Print trailing space for equal spacing
    li $v0, 11
    li $a0, 32
    syscall

continue_inner_loop:
    addi $t0, $t0, 4   # Move to the next element
    subi $t3, $t3, 1   # Decrement column counter
    bnez $t3, inner_loop  # Continue inner loop if not all columns printed

    # Print a newline
    li $v0, 11
    li $a0, 10
    syscall

    subi $t2, $t2, 1   # Decrement row counter
    j loop

done:
    jr $ra
