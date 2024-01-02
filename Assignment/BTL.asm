.data
	grid_1: .space 196
	grid_2: .space 196
	welcome: .asciiz "Welcome to the BattleShip Games! We will begin the input phase\nEach player will have 1 4x1 ship, 2 3x1 ships and 3 2x1 ships"
	turn_player_1 : .asciiz "TURN OF PLAYER A:\n"
	turn_player_2 : .asciiz "TURN OF PLAYER B:\n"
	ask_user_enter_ship_1: .asciiz "- Please enter the location of your"
	ask_user_enter_ship_2: .asciiz "ship, remeber that the input must be in [0,6]\n"
	error_shape_prompt: .asciiz "WARNING!!!: The ship you have entered doesn't have the correct shape! Please enter again\n"
	error_overlap_prompt: .asciiz "WARNING!!!: The ship you have entered overlap with other ship! Please enter again\n\n"
	error_out_of_range_prompt: .asciiz "WARNING!!!: The number you enter is out of [0,6], please enter again"
	enter_first_prompt: .asciiz "+ Enter the row of the bow: "
	enter_second_prompt: .asciiz "+ Enter the column of the bow: "
	enter_third_prompt: .asciiz "+ Enter the row of the stern : "
	enter_fourth_prompt: .asciiz "+ Enter the column of the stern: "
	successful_enter_1: .asciiz "->CONGRATULATION! Your"
	successful_enter_2: .asciiz "ship location: ["
	successful_enter_3: .asciiz "] is acceptible!\n"
	input_error: .asciiz "The input is in wrong format. So sorry but you lost your turn!!!\n"
	overload_enter_prompt: .asciiz "The number you entered is out of range and not acceptible. You lost your turn\n"
	over_2x1: .asciiz "WARNING!!!: You mustn't have more than 3 2x1 ship, please enter again!\n\n"
	over_3x1: .asciiz "WARNING!!!: You mustn't have more than 2 3x1 ship, please enter again!\n\n"
	over_4x1: .asciiz "WARNING!!!: You mustn't have more than 1 4x1 ship, please enter again!\n\n"
	map_prompt: .asciiz "This is your fleet map after input:\n"
	begin_play_prompt: .asciiz "COMPLETE THE INPUT SECTION, LET'S PLAY THE GAME!!!\n"
	first: .asciiz " first "
	second: .asciiz " second "
	third: .asciiz " third "
	fourth: .asciiz " fourth "
	fifth: .asciiz " fifth "
	sixth: .asciiz " sixth "
	hit: .asciiz "RESULT: HIT! "
	miss: .asciiz "RESULT: MISS! "
	miss_error: .asciiz "RESULT: MISS (due to wrong format input). "
	space: .asciiz " "
	endline: .asciiz "\n"
	end: .asciiz "THE GAME IS OVER!!!\n"
	enter_play_prompt: .asciiz "Enter two coordinates in range [0,6] to attack, remember to separate two numbers by only 1 backspace: "
	enter_row_coordinate: .asciiz "Enter the row coordinate: "
	enter_col_coordinate: .asciiz "Enter the column coordinate: "
	A_win: .asciiz "Player A win!!! The fleet of player B is destroyed completely!\n"
	B_win: .asciiz "PLayer B win!!! The fleet of player A is destroyed completely!\n"
	showing_grid_1: .space 49
	showing_grid_2: .space 49
	empty: .asciiz "~"
	missing: .asciiz "O"
	hitting: .asciiz "X"
	remain: .asciiz " hit remain to WIN! \n\n"
	explain_shown_grid: .asciiz "In each turn of each player, a grid will be shown to illustrate hit position ('X') and miss position ('O')\n"
	asking_see_remain: .asciiz "Would you like to see the remain fleet of each player?\nEnter 1 for YES or 0 for NO: "
	player_A_map: .asciiz "Player A 's fleet: \n"
	player_B_map: .asciiz "Player B 's fleet: \n"
	buffer: .space 20
	string: .space 20
.text
.globl main
main:

	jal welcome_and_init
	jal player_input
	jal exit
	
welcome_and_init:
	#Print welcome statement
	#Open file
	
	la $a0, welcome
	li $v0, 4
	syscall
	li $a0, 10
	li $v0, 11
	syscall
	#Load address of grid_1 and grid_2 to $a0 and $a1
	la $a0, grid_1
	la $a1, grid_2
	la $a2, showing_grid_1
	la $a3, showing_grid_2
	li $t1, 49
	li $t2, 0
	init_table:
		sw $zero, ($a0)
		sw $zero, ($a1)
		addi $a0, $a0, 4
		addi $a1, $a1, 4
		addi $t2, $t2, 1
		bne $t2, $t1, init_table
	li $t2, 0
	init_table_2:
		lb $t9, empty
		sb $t9, ($a2)
		sb $t9, ($a3)
		addi $a2, $a2, 1
		addi $a3, $a3, 1
		addi $t2, $t2, 1
		bne $t2, $t1, init_table_2
	jr $ra
	#Ending the init

player_input:
	# In this procedure, the number of each kind of ship 4x1, 3x1, 2x1 
	# will be store in $s0 = 1, $s1 = 2, $s2 = 3
	# $t0, $t1 will be use for the while loop; $t2, $t3, $t4 will be used for storing the 4 number
	# input from the keyboard
	# The base address of each grid will be stored consequently in $s3
	li $s0, 1
	li $s1, 2
	li $s2, 3
	player_1_input:
		la $a0, turn_player_1
		li $v0, 4
		syscall
		li $t0, 0 #Counter for the while loop
		li $t1, 6 #The number of ship that can be input
		while_input_1:
			#Get the 4 number entered by the user, additionally check the error while input
			la $s3, grid_1
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal get_four_numbers
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $t0, 1
			beq $t0, 6, continue_while_input_1
			la $a0, map_prompt
			li $v0, 4
			syscall
			la $a1, grid_1
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			addi $sp, $sp, -4
			sw $t1, 0($sp)
			jal print
			lw $t1, 0($sp)
			addi $sp, $sp, 4
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			continue_while_input_1:
			bne $t0, $t1, while_input_1
	la $a0, endline
	syscall
	li $s0, 1
	li $s1, 2
	li $s2, 3
	player_2_input:
		la $a0, turn_player_2
		li $v0, 4
		syscall
		li $t0, 0 #Counter for the while loop
		li $t1, 6 #The number of ship that can be input
		la $s3, grid_2
		while_input_2:
			#Get the 4 number entered by the user, additionally check the error while input
			la $s3, grid_2
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal get_four_numbers
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $t0, 1
			beq $t0, 6, continue_while_input_2
			la $a0, map_prompt
			li $v0, 4
			syscall
			la $a1, grid_2
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			addi $sp, $sp, -4
			sw $t1, 0($sp)
			jal print
			lw $t1, 0($sp)
			addi $sp, $sp, 4
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			continue_while_input_2:
			bne $t0, $t1, while_input_2
	la $a0, endline
	li $v0, 4
	syscall
	j play
set_a0_based_on_t0:
	beq $t0, 0, first_prompt
	beq $t0, 1, second_prompt
	beq $t0, 2, third_prompt
	beq $t0, 3, fourth_prompt
	beq $t0, 4, fifth_prompt
	beq $t0, 5, sixth_prompt
	first_prompt:
		la $a0, first
		jr $ra
	second_prompt:
		la $a0, second
		jr $ra
	third_prompt:
		la $a0, third
		jr $ra
	fourth_prompt:
		la $a0, fourth
		jr $ra
	fifth_prompt:
		la $a0, fifth
		jr $ra
	sixth_prompt:
		la $a0, sixth
		jr $ra
get_four_numbers:
	# This function get 4 number input from the user and store it in $t2, $t3, $t4, $t5
	# The $t6 will be used to check whether the ship you enter is of correct shape or not
	# Ask the user to enter the location of ship
	la $a0, ask_user_enter_ship_1
	syscall
	# Set the $a0 based on $t0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_a0_based_on_t0
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	la $a0, ask_user_enter_ship_2
	syscall
	#Begin enter the location of the ship
	Enter_first_number:
		la $a0, enter_first_prompt
		syscall
		li $v0, 5
		syscall
		move $t2, $v0
		ble $t2, -1 , fail_enter_first
		ble $t2, 6, Enter_second_number
		fail_enter_first:
		li $v0, 4
		la $a0, error_out_of_range_prompt
		syscall
		la $a0, endline
		syscall
		j Enter_first_number
	Enter_second_number:
		li $v0, 4
		la $a0, enter_second_prompt
		syscall
		li $v0, 5
		syscall
		move $t3, $v0
		ble $t3, -1, fail_enter_second
		ble $t3, 6, Enter_third_number
		fail_enter_second:
		li $v0, 4
		la $a0, error_out_of_range_prompt
		syscall
		la $a0, endline
		syscall
		j Enter_second_number
	Enter_third_number:
		li $v0, 4
		la $a0, enter_third_prompt
		syscall
		li $v0, 5
		syscall
		li $t6, 0
		move $t4, $v0
		ble $t4, -1, fail_enter_third
		ble $t4, 6, Check_size_1
		fail_enter_third:
		li $v0, 4
		la $a0, error_out_of_range_prompt
		syscall
		la $a0, endline
		syscall
		j Enter_third_number
	Check_size_1:
		bne $t2, $t4, Enter_fourth_number
		li $t6, 1
	Enter_fourth_number:
		li $v0, 4
		la $a0, enter_fourth_prompt
		syscall
		li $v0, 5
		syscall
		move $t5, $v0
		ble $t5, -1, fail_enter_fourth
		ble $t5, 6, check_size_2
		fail_enter_fourth:
		li $v0, 4
		la $a0, error_out_of_range_prompt
		syscall
		la $a0, endline
		syscall
		j Enter_fourth_number
	check_size_2:
		beq $t3, $t5, check_size_3
		beq $t6, 1, check_size_3
		la $a0, error_shape_prompt
		li $v0, 4
		syscall
		la $a0, endline
		syscall
		j get_four_numbers
	check_size_3:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal size_of_ship
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		ble $t9, 1, fault_size
		ble $t9, 4, check_count
		fault_size:
		la $a0, error_shape_prompt
		li $v0, 4
		syscall
		la $a0, endline
		syscall
		j get_four_numbers
	check_count:
		beq $t9, 2, count_2x1
		beq $t9, 3, count_3x1
		beq $t9, 4, count_4x1
	count_2x1:
		addi $s2, $s2, -1
		bgez $s2, check_overlap
		addi $s2, $s2, 1
		la $a0, over_2x1
		li $v0, 4
		syscall
		j get_four_numbers
	count_3x1:
		addi $s1, $s1, -1
		bgez $s1, check_overlap
		addi $s1, $s1, 1
		la $a0, over_3x1
		li $v0, 4
		syscall
		j get_four_numbers
	count_4x1:
		addi $s0, $s0, -1
		bgez $s0, check_overlap
		addi $s0, $s0, 1
		la $a0, over_4x1
		li $v0, 4
		syscall
		j get_four_numbers
	check_overlap:
		move $s4, $s3
		beq $t2, $t4, check_overlap_row
		beq $t3, $t5, check_overlap_col
		check_overlap_row:
			addi $sp, $sp, -4
			sw $t3, 0($sp)
			addi $sp, $sp, -4
			sw $t5, 0($sp)
			blt $t3, $t5, continue_check_overlap_row #If t3 > t5, swap t3 and t5
			add $t6, $zero, $t3
			add $t3, $zero, $t5
			add $t5, $zero, $t6
			continue_check_overlap_row:
			li $t6, 0
			mul $t7,  $t2, 7
			add $t7, $t7, $t3
			for_idx_overlap_row:
				beq $t6, $t7, end_for_idx_overlap_row
				addi $s4, $s4, 4
				addi $t6, $t6, 1
				j for_idx_overlap_row
			end_for_idx_overlap_row:
			li $t6, 0
			for_overlap_row:
				beq $t6, $t9, end_overlap_row
				lw $t8, ($s4)
				bne $t8, 1, continue_for_overlap_row
				la $a0, error_overlap_prompt
				li $v0, 4
				syscall
				beq $t9, 2, add_2x1
				beq $t9, 3, add_3x1
				beq $t9, 4, add_4x1
				add_2x1:
				addi $s2, $s2, 1
				j get_four_numbers
				add_3x1:
				addi $s1, $s1, 1
				j get_four_numbers
				add_4x1:
				addi $s0, $s0, 1
				j get_four_numbers
				continue_for_overlap_row:
				addi $t6, $t6, 1
				addi $s4, $s4, 4
				j for_overlap_row
			end_overlap_row:
			lw $t5, 0($sp)
			addi $sp, $sp, 4
			lw $t3, 0($sp)
			addi $sp, $sp, 4
			j after_enter
		check_overlap_col:
			move $s4, $s3
			addi $sp, $sp, -4
			sw $t2, 0($sp)
			addi $sp, $sp, -4
			sw $t4, 0($sp)
			blt $t2, $t4, continue_check_overlap_col #If t3 > t5, swap t3 and t5
			add $t6, $zero, $t2
			add $t2, $zero, $t4
			add $t4, $zero, $t6
			continue_check_overlap_col:
			li $t6, 0
			mul $t7,  $t2, 7
			add $t7, $t7, $t3
			for_idx_overlap_col:
				beq $t6, $t7, end_for_idx_overlap_col
				addi $s4, $s4, 4
				addi $t6, $t6, 1
				j for_idx_overlap_col
			end_for_idx_overlap_col:
			li $t6, 0
			for_overlap_col:
				beq $t6, $t9, end_overlap_col
				lw $t8, ($s4)
				bne $t8, 1, continue_for_overlap_col
				la $a0, error_overlap_prompt
				li $v0, 4
				syscall
				beq $t9, 2, add_2x1_col
				beq $t9, 3, add_3x1_col
				beq $t9, 4, add_4x1_col
				add_2x1_col:
				addi $s2, $s2, 1
				j get_four_numbers
				add_3x1_col:
				addi $s1, $s1, 1
				j get_four_numbers
				add_4x1_col:
				addi $s0, $s0, 1
				j get_four_numbers
				continue_for_overlap_col:
				addi $t6, $t6, 1
				addi $s4, $s4, 28
				j for_overlap_col
			end_overlap_col:
			lw $t4, 0($sp)
			addi $sp, $sp, 4
			lw $t2, 0($sp)
			addi $sp, $sp, 4
			j after_enter
	after_enter:
	li $v0, 4
	la $a0, successful_enter_1
	syscall
	# Set the $a0 based on $t0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal set_a0_based_on_t0
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	la $a0, successful_enter_2
	syscall
	li $v0, 1
	add $a0, $zero, $t2
	syscall
	la $a0, space
	li $v0, 4
	syscall
	li $v0, 1
	add $a0, $zero, $t3
	syscall
	la $a0, space
	li $v0, 4
	syscall
	li $v0, 1
	add $a0, $zero, $t4
	syscall
	la $a0, space
	li $v0, 4
	syscall
	li $v0, 1
	add $a0, $zero, $t5
	syscall
	li $v0, 4
	la $a0, successful_enter_3
	syscall
	la $a0, endline
	syscall
	fill_the_ship:
		#This procedure filling the ship with the size stored in $t9, remember that the base address of the grid stored in $s3
		beq $t2, $t4, fill_row
		beq $t3, $t5, fill_col
		fill_row:
			blt $t3, $t5, continue_fill_row #If t3 > t5, swap t3 and t5
			add $t6, $zero, $t3
			add $t3, $zero, $t5
			add $t5, $zero, $t6
			continue_fill_row:
			li $t6, 0
			mul $t7,  $t2, 7
			add $t7, $t7, $t3
			for_to_idx_row:
				beq $t6, $t7, end_for_to_idx_row
				addi $s3, $s3, 4
				addi $t6, $t6, 1
				j for_to_idx_row
			end_for_to_idx_row:
			li $t8, 1
			li $t6, 0
			for_fill_row:
				beq $t6, $t9, finishing_enter
				sw $t8, ($s3)
				addi $t6, $t6, 1
				addi $s3, $s3, 4
				j for_fill_row
		fill_col:		
			blt $t2, $t4, continue_fill_col #If t2 > t4, swap t2 and t4
			add $t6, $zero, $t2
			add $t2, $zero, $t4
			add $t4, $zero, $t6
			continue_fill_col:
			li $t6, 0
			mul $t7,  $t2, 7
			add $t7, $t7, $t3
			for_to_idx_col:
				beq $t6, $t7, end_for_to_idx_col
				addi $s3, $s3, 4
				addi $t6, $t6, 1
				j for_to_idx_col
			end_for_to_idx_col:
			li $t8, 1
			li $t6, 0
			for_fill_col:
				beq $t6, $t9, finishing_enter
				sw $t8, ($s3)
				addi $t6, $t6, 1
				addi $s3, $s3, 28
				j for_fill_col
	finishing_enter:
	jr $ra

size_of_ship:
	#This function return the size of ship get from $t2, $t3, $t4, $t5 and store it in $t9
	#This function will use the temp register $t6 for conventiently calculating the value
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	sub $t6, $t2, $t4
	sub $t9, $t3, $t5
	add $t9, $t9, $t6
	bgtz $t9, end_size_of_ship
	sub $t9, $zero, $t9
	end_size_of_ship:
	addi $t9, $t9, 1
	lw $t6, 0($sp)
	addi $sp, $sp, 4
	jr $ra
print:	
	#The base address of the grid must be located in $a1
	li $t0, 7 #Save the value of Row
	li $t1, 7 #Save the value of Row
	li $t2, 0
	li $t3, 0
	move $s7, $a1
	print_outer:
		li $t0, 7
		li $t2, 0
		print_inner:
			#Print the number at A[i]
			lw $t6, ($s7)
			move $a0, $t6
			li $v0, 1
			syscall
			la $a0, space
			li $v0, 4
			syscall
			addi $s7, $s7, 4
			addi $t2, $t2, 1
			bne $t2, $t0, print_inner
		addi $t3, $t3, 1
		la $a0, endline
		li $v0, 4
		syscall
		bne $t3, $t1, print_outer
	la $a0, endline
	li $v0, 4
	syscall
	jr $ra

print_special:	
	#The base address of the grid must be located in $a1
	li $t0, 7 #Save the value of Row
	li $t1, 7 #Save the value of Row
	li $t2, 0
	li $t3, 0
	move $s7, $a1
	print_outer_special:
		li $t0, 7
		li $t2, 0
		print_inner_special:
			#Print the number at A[i]
			lb $t6, ($s7)
			move $a0, $t6
			li $v0, 11
			syscall
			la $a0, space
			li $v0, 4
			syscall
			addi $s7, $s7, 1
			addi $t2, $t2, 1
			bne $t2, $t0, print_inner_special
		addi $t3, $t3, 1
		la $a0, endline
		li $v0, 4
		syscall
		bne $t3, $t1, print_outer_special
	la $a0, endline
	li $v0, 4
	syscall
	jr $ra

play:
	la $a0, begin_play_prompt
	li $v0, 4
	syscall
	li $s0, 16 #The number of 1s in player A fleet
	li $s1, 16 #The number of 1s in player B fleet
	li $t9, 0 #The value stored in $t9 = 0 -> The turn for player A
	while_play:
		beq $t9, 0, player_A_turn
		bnez $t9, player_B_turn
		player_A_turn:		
			la $s2, grid_2
			la $s3, showing_grid_2
			la $s4, showing_grid_2
			la $a0, turn_player_1
			li $v0, 4
			syscall			
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal enter_two_coordinate_and_move
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			beqz $t8, player_A_miss
			beq $t8, -1, player_A_miss
			beq $t8, -2, player_A_miss
			beq $t8, 1, player_A_hit
			player_A_miss:
			beq $t8, -2, A_error
			la $a0, miss
			j continue_miss_A
			A_error:
			la $a0, miss_error
			continue_miss_A:
			li $v0, 4
			syscall
			lb $t7, missing
			bnez $t8, continue_player_A_miss
			sb $t7, ($s3)
			continue_player_A_miss:
			j finish_player_A
			player_A_hit:
			addi $s5, $zero, -1
			sw $s5, ($s2)
			la $a0, hit
			li $v0, 4
			syscall
			lb $t7, hitting
			sb $t7, ($s3)
			addi $s1, $s1, -1
			bnez $s1, finish_player_A #PLayer A win
			la $a0, A_win
			li $v0, 4
			syscall
			move $a1, $s4
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal print_special
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			j exit
			finish_player_A:
			li $v0, 1
			move $a0, $s1
			syscall
			li $v0, 4
			la $a0, remain
			syscall
			addi $t9, $t9, 1
			move $a1, $s4
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal print_special
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			j while_play
		player_B_turn:
			la $s2, grid_1
			la $s3, showing_grid_1
			la $s4, showing_grid_1
			la $a0, turn_player_2
			li $v0, 4
			syscall	
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal enter_two_coordinate_and_move
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			beqz $t8, player_B_miss
			beq $t8, -1, player_B_miss
			beq $t8, -2, player_B_miss
			beq $t8, 1, player_B_hit
			player_B_miss:
			beq $t8, -2, B_error
			la $a0, miss
			j continue_miss_B
			B_error:
			la $a0, miss_error
			continue_miss_B:
			la $a0, miss
			li $v0, 4
			syscall
			lb $t7, missing
			bnez $t8, continue_B_miss
			sb $t7, ($s3)
			continue_B_miss:
			j finish_player_B
			player_B_hit:
			addi $s5, $zero, -1
			sw $s5, ($s2)
			la $a0, hit
			li $v0, 4
			syscall
			lb $t7, hitting
			sb $t7, ($s3)
			addi $s0, $s0, -1
			bnez $s0, finish_player_B #PLayer B win
			la $a0, B_win
			li $v0, 4
			syscall
			move $a1, $s4
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal print_special
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			j exit
			finish_player_B:
			li $v0, 1
			move $a0, $s0
			syscall
			li $v0, 4
			la $a0, remain
			syscall
			addi $t9, $t9, -1
			move $a1, $s4
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal print_special
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			j while_play
	jr $ra

enter_two_coordinate_and_move:
	#This function get 2 number from the user and stored it in $t0 and $t1
	la $a0, enter_row_coordinate
	li $v0, 4
	syscall 
	
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	syscall
	
	li $t0, 0
	la $t1, buffer
	calculate_length:
		lb $t2, 0($t1)
		beqz $t2, exit_calculate
	
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j calculate_length
	exit_calculate:
	ble $t0, 4, continue
	la $a0, input_error
	li $v0, 4
	syscall
	addi $t8, $zero, -2
	j end_func
	
	continue:
	li $t0, 0
	li $t1, 0
	li $t2, 0

	lb $t3, buffer($t0)
	li $t4, 32
	sub $t1, $t3, 48
	
	addi $t0, $t0, 2
	lb $t3, buffer($t0)
	sub $t2, $t3, 48
	
	ble $t1, -1 , overload_error
	bgt $t1, 6, overload_error
	ble $t2, -1 , overload_error
	bgt $t2, 6, overload_error
	j continue_program
overload_error:
	la $a0, overload_enter_prompt
	li $v0, 4
	syscall
	addi $t8, $zero, -2
	j end_func
continue_program:
	move $t0, $t1
	move $t1, $t2
	move_to_coordinate:
	#This function move $s2 to grid[i][j], $s2 stored the address grid[][], i in $t1 and j in $t2
	# And return the value of grid[i][j] in $t8
	li $t6, 0
	mul $t7,  $t0, 7
	add $t7, $t7, $t1
	for_idx:
		beq $t6, $t7, end_for_idx
		addi $s2, $s2, 4
		addi $t6, $t6, 1
		j for_idx
	end_for_idx:
	li $t6, 0
	move_to_shown:
		beq $t6, $t7, end_shown
		addi $s3, $s3, 1
		addi $t6, $t6, 1
		j move_to_shown
	end_shown:
	lw $t8, ($s2)
	end_func:
	jr $ra
exit:
	la $a0, end
	li $v0, 4
	syscall
	la $a0, asking_see_remain
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	beqz $v0, not_showing_remain
	la $a0, player_A_map
	li $v0, 4
	syscall
	
	li $t0, 0
	li $t1, 49
	la $s0, grid_1
	grid_1_zero:
	beq $t0, $t1, exit_grid_1_zero
	lw $t2, ($s0)
	bne $t2, -1, continue_grid_1_zero
	sw $zero, ($s0)
	continue_grid_1_zero:
	addi $t0, $t0, 1
	addi $s0, $s0, 4
	j grid_1_zero
	exit_grid_1_zero:
	la $a1, grid_1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	jal print
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, player_B_map
	li $v0, 4
	syscall
	
	li $t0, 0
	li $t1, 49
	la $s0, grid_2
	grid_2_zero:
	beq $t0, $t1, exit_grid_2_zero
	lw $t2, ($s0)
	bne $t2, -1, continue_grid_2_zero
	sw $zero, ($s0)
	continue_grid_2_zero:
	addi $t0, $t0, 1
	addi $s0, $s0, 4
	j grid_2_zero
	exit_grid_2_zero:
	la $a1, grid_2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	jal print
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
not_showing_remain:
	li $v0, 10
    	syscall
