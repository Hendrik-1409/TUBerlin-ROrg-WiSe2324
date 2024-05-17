	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

decoder_heap: .asciiz "_ETIANMSURWDKGOHVF*L*PJBXCYZQ**54*3***2&*+****16=/***(*7***8*90"
str_eingabe: .asciiz "morse_in: "
str_ausgabe: .asciiz "\ntext_out: "
str_rueckgabewert: .asciiz "\nRueckgabewert: "
buf_out: .space 256

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	# Morsecode-Eingabe wird ausgegeben:
	li $v0, SYS_PUTSTR
	la $a0, str_eingabe
	syscall

	li $v0, SYS_PUTSTR
	la $a0, test_msg
	syscall
	
	li $v0, SYS_PUTSTR
	la $a0, str_rueckgabewert
	syscall

	move $v0, $zero
	# Aufruf der Funktion morse:
	la $a0, decoder_heap
	la $a1, test_msg
	la $a2, buf_out
	jal morse
	
	# Rueckgabewert und Ausgabetext wird ausgegeben:
	move $a0, $v0
	li $v0, SYS_PUTINT
	syscall

	li $v0, SYS_PUTSTR
	la $a0, str_ausgabe
	syscall

	li $v0, SYS_PUTSTR
	la $a0, buf_out
	syscall

	# Ende der Programmausfuehrung:
	li $v0, SYS_EXIT
	syscall


	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname: Hendrik
	# Nachname: Schiele
	# Matrikelnummer: 0499890
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

#test_msg: .asciiz ".... .- .-.. .-.. ---"
test_msg: .asciiz "-- .. .--. ...  .. ... -  - --- .-.. .-.."

.text

morse:
	li		$t0, 0		# $t0 = 0 - baumposition k
	li		$t2, 0		# $t2 = 0 - adresseniterator
	add		$t2, $t2, $a1		# $t2 = $t2 + $a1
	li		$t3, 0		# $t3 = 0 - position im ausgabestring
	
	

	decodestep: 
		lb		$t1, 0($t2)		# aktuelles Morsezeichen
		beq		$t1, ' ', addLetter	# if $t1 == ' ' then goto addLetter
		beq		$t1, '\0', endDecode	# if $t1 == '\0' then goto endDecode
		beq		$t1, '-', Strich	# if $t1 == '-' then goto Strich
		add		$t0, $t0, $t0		# $t0 = $t0 + $t0
		addi		$t0, $t0, 1		# $t0 = $t0 + 1
		j		iteration				# jump to iteration
		

		iteration:
			addi	$t2, $t2, 1			# $t2 = $t2 + 1
			j		decodestep				# jump to decodestep
			
			
		
		Strich:
			add		$t0, $t0, $t0		# $t0 = $t0 + $t0
			addi		$t0, $t0, 2		# $t0 = $t0 + 2
			j		iteration				# jump to iteration
			


	addLetter:
		add		$t0, $t0, $a0		# $t0 = $t0 + $a0
		lb		$t0, 0($t0)		# 
		add		$t4, $t3, $a2		# $t4 = $t3 + $v0		
		sb		$t0, 0($t4)		# 
		addi	$t3, $t3, 1			# $t3 = $t3 + 1		
		li		$t0, 0		# $t0 = 0 - baumposition k
		j		iteration				# jump to iteration

	endDecode:
		add		$t0, $t0, $a0		# load current address of tree inplace
		lb		$t0, 0($t0)			# load char from tree inplace
		add		$t4, $t3, $a2		# load output arddress in t4
		sb		$t0, 0($t4)			# save loaded char to t4
		addi $v0, $t3, 1 # set output to length of output string in bytes

		jr $ra