class MastermindGame
	
	def initialize
		@code = Array.new
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
		make_guess
	end

	def make_guess
		guess = computer_generate_code
		@cheater.each { |key, value| guess[key] = value }
		puts guess
		turn_number
		check_computer_answer(guess)
		make_guess()

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
		puts "Welcome to Mastermind, type 1 to be the codebreaker, or 2 to be the codemaker\nAnything else will exit the game."
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
		@x.times { @code << @options.sample }
		return @code
	end

	def ask_for_guess
		puts "Turn \##{@turn_number}\nwhat is your guess?"
		guess = gets.chomp
		unless guess.length == @x
			puts "The guess must be #{@x} numbers long, try again"
			ask_for_guess
		end
		begin
			guess = guess.chars.map {|i| i.to_i }
			puts guess.join(" ")
		rescue
			puts "Please enter a valid guess using only combinations of 1, 2, 3, 4, 5, or 6."
		else
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

end


game = MastermindGame.new
