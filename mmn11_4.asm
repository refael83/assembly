# Title: Lab1        	Filename:
# Author:       	Date:
# Description:
# Input: $s0= a word hexa 8 digit number
# Output: $t0= the number of even hexa digits
################# Data segment #####################
.data
msg1: .asciiz "\nPlease enter a decimal number   between 0 and 9:\n"
msg2: .asciiz "Error: Invalid input. Please enter a valid number.\n"
p: .asciiz  "p "
b: .asciiz  "b "
bool: .word 0,0,0
guess:  .word 0,0,0
input_guess: .space 32 
################# Code segment #####################
.text
.globl main
main:	# main program entry

	# Print prompt message
    li $v0, 4       # System call for print_str
    la $a0, msg1    # Load address of msg1 into $a0
    syscall
    
    la $a1,bool
    
       # Get user input
input:    li $v0, 12       # System call for read_int
          syscall
          blt $v0, 48, invalid_input
          bgt $v0, 57, invalid_input
          sw $v0,0($a1)
          addi $a1,$a1,4 
          addi $t0,$t0,1
          blt  $t0,3,input
 
 get_guess:la $a2,guess
           add $a1,$0,23
           sub $t0,$t0,$t0
           li $v0, 8 #stored in address of a0
           la $a0,input_guess
	   syscall
	   
insert_to_array:
	
       lb $t2,input_guess($t0)
       blt $t2, '0', invalid_guess_input
       bgt $t2, '9', invalid_guess_input
       sb  $t2,0($a2)
       addi $a2,$a2,1 
       addi $t0,$t0,1
       blt  $t0,3,insert_to_array
       
       	la $a0,guess #address of guess array
	la $a1,bool  #address of bool array   
loop:
	lw $t0,0($a0) #t0 = guess[t3]
loop2:
	lw $t1,0($a1) #t1 = bool[t4]
	sub $t2,$t1,$t0
	sub $t5,$t4,$t3
	beqz $t2,equal
continu:
	addi  $t4,$t4,1
	addi  $a1,$a1,4
	blt  $t4,2,loop2
	
	addi $t3,$t3,1
	addi $a0,$a0,4
	blt $t3,2,loop	
	
	  # Exit the program
    li $v0, 10      # System call for exit
    syscall



invalid_input:
    # Print error message
    li $v0, 4       # System call for print_str
    la $a0, msg2    # Load address of msg2 into $a0
    syscall    
    j input
    
invalid_guess_input:
	li $v0, 4       # System call for print_str
        la $a0, msg2    # Load address of msg2 into $a0
        syscall    
        j get_guess

equal:
	beqz $t5,boo
	la $a0, p
    	li $v0,4
    	syscall
    	j continu
boo:
	la $a0, b
    	li $v0,4
    	syscall
    	j continu
	       
