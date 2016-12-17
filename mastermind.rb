class MastermindGame
	
	def initialize
		@x = 4 #length of secret code
		@options = [1, 2, 3, 4, 5, 6]
		@turn_number = 1
		welcome_introduction
	end

	def code_breaker_initialize
		@master = computer_generate_code
		ask_for_guess
	end

	def code_maker_initialize
		@master = player_generate_code
		@cheater = {}
		make_guess
	end

	def player_generate_code
		puts "OK, using only the numbers 1, 2, 3, 4, 5, or 6, enter the best #{@x} digit code you can think of."
		secret_code = gets.chomp
		secret_code = user_input_check(secret_code, "code"){player_generate_code}
		puts secret_code.join(" ")
		return secret_code
  end 

	def make_guess
		guess = computer_generate_code
		@cheater.each { |key, value| guess[key] = value }
		puts "\nComputer's turn number: #{@turn_number}\n Guess: #{guess}"
		check_computer_answer(guess)
		if guess == @master
			puts "Bow down to your new mahine overlord... the computer has cracked your best code in only #{@turn_number} tries."
		else
			unless @turn_number == 12
				new_turn
				make_guess()
			else 
				puts "Wow, I can't believe it, you fought the machine and won!"
			end
		end
	end

	def check_computer_answer(guess)
		half_correct = 0
		full_correct = 0
		minor = []
		@cheater = {}
		@master.each { |each| minor << each }
		for i in 0...@x
			if minor.include? guess[i]
				half_correct += 1 
				dupe = minor.find_index(guess[i])
				minor[dupe] = "x" 
			end
			if @master[i] == guess[i]
				@cheater[i] = @master[i]
				half_correct -= 1
				full_correct += 1
			end
		end
		puts "Number exactly correct: #{full_correct}\nNumber partially correct: #{half_correct}"
	end

	def welcome_introduction
		puts <<~HEREDOC
					Welcome to Mastermind, here is how it is played.
					 The codemaker will create a #{@x} digit combination using the 
					 numbers 1, 2, 3, 4, 5, and 6. Duplicates are allowed. The 
					 codebreaker will then have 12 turns to correctly guess the 
					 code. After each guess, the codebreaker will be told how many 
					 numbers were guessed EXACTLY correct (correct number and 
					 placement) and how many were only PARTIALLY correct (correct 
					 number but not placement).

					 Type 1 to be the codebreaker, or 2 to be the codemaker
					 Anything else will exit the game.
					 HEREDOC
		answer = gets.chomp
		if answer == "1"
			code_breaker_initialize
		elsif answer == "2"
			code_maker_initialize
		else
			exit
		end
	end

	def computer_generate_code
		@code = []
		@x.times { @code << @options.sample }
		return @code
	end

	def ask_for_guess
		puts "Turn \##{@turn_number}\nwhat is your guess?"
		guess = gets.chomp
		user_input_check(guess, "guess"){ask_for_guess}
		guess = guess.chars.map { |i| i.to_i }
		puts guess.join(" ")
		if guess == @master
			winner
		elsif @turn_number == 12
			puts "Thats all you get, better luck next time!\nSince it's probably killing you, the winning code was #{@master.join(' ')}"
		else
			check_player_answer(guess)
			new_turn
			ask_for_guess
		end
	end

	def winner
		puts "You win! You masterminded the whole thing, didn't you?\nWinning code: #{@master.join(" ")}\nWould you like to play again? (y to play again, anything else will exit the game)"
		start_over = gets.chomp
		MastermindGame.new if start_over == "y"
		exit
	end

	def new_turn
		@turn_number += 1
	end

	def check_player_answer(guess)
		half_correct = 0
		full_correct = 0
		minor = []
		@master.each { |each| minor << each }
		for i in 0...@x
			if minor.include? guess[i]
				half_correct += 1 
				dupe = minor.find_index(guess[i])
				minor[dupe] = "x" 
			end
			if @master[i] == guess[i]
				half_correct -= 1
				full_correct += 1
			end
		end
		puts "Number exactly correct: #{full_correct}\nNumber partially correct: #{half_correct}"
	end

	def user_input_check(user_input, name_string)
		unless user_input.length == @x
			puts "The #{name_string} must be #{@x} numbers long, try again"
			yield
		end
		user_input = user_input.chars.map { |i| i.to_i }
		user_input.each do |i| 
			unless @options.include? i
				puts "Please enter a valid #{name_string} using only combinations of 1, 2, 3, 4, 5, or 6."
				yield
			end
		end
		return user_input
	end

end


game = MastermindGame.new
