class MastermindGame
	
	def initialize
		@code = Array.new
		@x = 4 #length of secret code
		@options = [1, 2, 3, 4, 5, 6]
		@master = generate_code
		@turn_number = 1
		ask_for_guess
	end

	def generate_code
		@x.times { @code << @options.sample }
		return @code
	end

	def ask_for_guess
		puts "Turn \# #{@turn_number}"
		puts "what is your guess?"
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
				puts "Thats all you get, better luck next time!"
				puts "Since it's probably killing you, the winning code was #{@master.join(' ')}"
			else
				check_answer(guess)
				new_turn
			end
		end
	end

	def winner
		puts "You win! You masterminded the whole thing, didn't you?"
		puts "Winning code: #{@master.join(" ")}"
		puts "Would you like to play again? (y/n)"
		start_over = gets.chomp
		MastermindGame.new if start_over == "y"
		exit
	end

	def new_turn
		@turn_number += 1
		p @master
		ask_for_guess

	end

	def check_answer(guess)
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
		puts "Number exactly correct: #{full_correct}"
		puts "Number partially correct: #{half_correct}"
	end

end


game = MastermindGame.new
