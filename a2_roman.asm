	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

str_eingabe: .asciiz "numeral: "
str_rueckgabewert: .asciiz "\nRueckgabewert: "
romdigit_table: .word 0, 0, 0, 100, 500, 0, 0, 0, 0, 1, 0, 0, 50, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 10, 0, 0, 0, 0, 0, 0, 0

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	# Roemische Zahl wird ausgegeben:
	li $v0, SYS_PUTSTR
	la $a0, str_eingabe
	syscall

	li $v0, SYS_PUTSTR
	la $a0, test_numeral
	syscall
	
	li $v0, SYS_PUTSTR
	la $a0, str_rueckgabewert
	syscall

	move $v0, $zero
	# Aufruf der Funktion roman:
	la $a0, test_numeral
	jal roman
	
	# Rueckgabewert wird ausgegeben:
	move $a0, $v0
	li $v0, SYS_PUTINT
	syscall

	# Ende der Programmausfuehrung:
	li $v0, SYS_EXIT
	syscall
	
	# Hilfsfunktion: int romdigit(char digit);
romdigit:
	move $v0, $zero
	andi $t0, $a0, 0xE0
	addi $t1, $zero, 0x40
	beq $t0, $t1, _romdigit_not_null
	addi $t1, $zero, 0x60
	beq $t0, $t1, _romdigit_not_null
	jr $ra
_romdigit_not_null:
	andi $t0, $a0, 0x1F
	sll $t0, $t0, 2
	la $t1, romdigit_table
	add $t1, $t1, $t0
	lw $v0, 0($t1)
	jr $ra

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:Hendrik
	# Nachname:Schiele
	# Matrikelnummer: 0499890
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

test_numeral: .asciiz "VIX"

.text

roman:

	addi	$sp, $sp, -8			# $sp = $sp - 8
	sw		$ra, 4($sp)		# 
	la 		$t0, 'A'		# $t0 = 'A'
	sw		$t0, 0($sp)		# 	
	li		$t0, 0		# $t0 = 0 - counter for stack push
	add		$t0, $t0, $a0		# $t0 = $t0 + $a0
	
	text_to_stack:
		lb		$t1, 0($t0)		# 
		beq		$t1, '\0', decode	# if $t1 == '\0' then goto decode		
		addi	$sp, $sp, -4			# $sp = $sp + -4 - stackpointer for next letter
		sw		$t1, 0($sp)		#
		addi	$t0, $t0, 1			# $t0 = $t0 + 1
		j		text_to_stack				# jump to text_to_stack		
		 
	decode:
		li		$t0, 0		# $t1 = 0
		li		$t1, 0		# $t1 = 0
		decode_loop:
		lw		$a0, 0($sp)		# 
		addi	$sp, $sp, 4	# $sp = $sp + 4
		beq		$a0, 'A', endDecode	# if $t1 == '\0' then goto decode
		addi	$sp, $sp, -8	# $sp = $sp + -8
		sw		$t0, 4($sp)		#				
		sw		$t1, 0($sp)		# 
		jal		romdigit				# jump to romdigit and save position to $ra

		lw		$t0, 4($sp)		#				
		lw		$t1, 0($sp)		# 
		addi	$sp, $sp, 8	# $sp = $sp + 8
		blt		$v0, $t1, sub_num	# if $v0 < $t1 then goto sub_num
		add		$t0, $t0, $v0		# $t0 = $t0 + $v0
		move 	$t1, $v0		# $t1 = $v0
		j		decode_loop				# jump to decode_loop		
		
		sub_num:
			sub		$t0, $t0, $v0		# $t0 = $t0 - $v0
			j		decode_loop				# jump to decode_loop
					
	endDecode:	
		lw		$ra, 0($sp)		# 
		addi	$sp, $sp, 4			# $sp = $sp + 4		
		move 	$v0, $t0		# $v0 = $01
		jr $ra