# Title:        	Filename: 
# Author:       	Date: 
# Description:
# Input: $s0= a word hexa 8 digit number
# Output: $t0= the number of even hexa digits
################# Data segment #####################
.data
msg1: .asciiz "\nPlease enter a decimal number (4 digits) in two's complement representation between -9999 and 9999:\n"
msg2: .asciiz "Error: Invalid input. Please enter a valid number.\n"
newline_str: .asciiz "\n"

.text

main:
    # Print prompt message
    li $v0, 4       # System call for print_str
    la $a0, msg1    # Load address of msg1 into $a0
    syscall

    # Get user input
    li $v0, 5       # System call for read_int
    syscall

    # Check if the entered value is within the valid range
    blt $v0, -9999, invalid_input
    bgt $v0, 99999, invalid_input

    # If the input is valid, print the entered number
    add $a2, $v0,$zero    # Move the entered value to $a0
   
    move $t3,$a2   # Move the entered value to $t3
    addi $t6,$zero,1   
    addi $t4,$zero,1  #mask to print in 16 bit
    addi $t2,$t2,16	#count the loop number
    addi $t6,$t6,14	#how mach add to number of revers bits

    loop:
    	and $a0,$t4,$t3   #move 0 or 1 to $a0 
    	bgt $t2,15,if_odd  #check if the lsb equal to 1 or 0
continue:
	sllv $a0,$a0,$t6  #$ao equal now to 2^$t6
    	add $t7,$t7,$a0   #add to number of revers bits
    	srlv $a0,$a0,$t6   #return $a0 to 0 or 1
    	addi $t6,$t6,-1
    	srl  $t3,$t3,1  #move one bit to left 
    	li  $v0,1
    	
    	syscall
    	addi $t2,$t2,-1  #count the loop number
    	bgt $t2,0,loop
    	
    	
    	addi $t2,$t2,16
    	la $a0, newline_str
    	li $v0,4
    	syscall
    	
    	add $a0,$zero, $t7
    	li $v0,1
    	syscall
    	
    	la $a0, newline_str
    	li $v0,4
    	syscall
    	
    	sll $t4,$t4,15	#mask to print in 16 bit
    	loop1:
    	and $a0,$t4,$a2	  #move 0 or 1 to  bit nuber 16 in $a0
    	srl $a0,$a0,15	  #mov the bit number 16 to bit numer 1
    	sll  $a2,$a2,1   #move one bit to left
    	li  $v0,1
    	syscall
    	addi $t2,$t2,-1  #count the loop number
    	bgt $t2,0,loop1
    	

    # Exit the program
    li $v0, 10      # System call for exit
    syscall

invalid_input:
    # Print error message
    li $v0, 4       # System call for print_str
    la $a0, msg2    # Load address of msg2 into $a0
    syscall

    # Repeat the input process
    j main          # Jump back to the main label

if_odd:
    bgt $a0,0,odd
    j continue
    
odd:
   lui $t7,0xffff
   j continue
