############################################################################################################################
# CMPEN 331 HW6 Test program
# Your check list
# 1. 0x000000ff is loaded $s3 form data memory finally.
# 2. $t3 and $t4 have same value.
# 3. Instruction memory load 'beq' when $t3 and $t4 have same value.
# You need to check above three things until your instruction memory load 'beq'.
# We will grade your modules with different initial value. However, if your modules work with this code, it must be work also.
############################################################################################################################

	.text
	.globl main

main:
	addi $s1, $s1,   0x2000 # 
	addi $t0, $zero, 0x004b
	addi $t1, $zero, 0x000f
	addi $t2, $zero, 3
	sub $t3, $t2, $t2      #0
	add $t4, $t2, $t2      #6
	sw  $t0, 4($s1)

loop_start:	
	lw   $s3, 4($s1)	 #$s3 will be 0x000000ff
	beq  $t3, $t4, loop_end  
	addi $t3, $t3, 1	
	sub  $t0, $t0, $t1
	andi $s2, $t0, 0x00f0
	or   $s3, $s2, $t1
	sw   $s3, 4($s1)
	j loop_start
	
loop_end: