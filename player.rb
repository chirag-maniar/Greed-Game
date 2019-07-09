require './dice_set'

class Player 
	attr_accessor :player
	def initialize(name)
		@player = {
			name: name,
			non_scoring: 5,
			temp_score: 0,
			fin_score: 0 
			
		}
		@player
	end

	def score(dice)
  		
  	  	
	  count = Hash.new(0) 
	  result = 0
	  dice.each { |val|
	    count[val] += 1
	  }
	  
	  count.each { |item, times|

	    if item == 1 && times >= 3 then
	      result += 1000
	      times -= 3
	      @player[:non_scoring] -= 3
	    
	    elsif item == 5 && times >= 3 then 
	      result += 500
	      times -= 3
	      @player[:non_scoring] -= 3
	    end
	    
	    if item == 5 && times <=2 then
	      result += 50 * times
	      @player[:non_scoring] -= times

	    elsif item != 1 && times >= 3 then
	      result += item * 100
	      @player[:non_scoring] -= times
	    
	    elsif item == 1 && times <= 2 then 
	      result += 100 * times
	      @player[:non_scoring] -= times
	    end

	  }
  
  	return result
	end

	def roll_dice(player) 
		temp = []
	  	diceset_obj = DiceSet.new
		temp = diceset_obj.roll(player[:non_scoring])
		puts "Player #{player[:name]+1} rolls: #{temp}"
		score(temp) 
	end

end

class Game
	def initialize()
		@players = []
		@last = {} 
		@last_player = 0 
		@rnd = 1 
	end


	def calculate(score, player) 
		i = player[:name].next
		puts "Score in this round: #{score}"
		puts "Total score: #{player[:fin_score]}"
		if (player[:temp_score] == 0  && score >= 0) || player[:temp_score] != 0
			if score != 0
				if player[:non_scoring]==0
					player[:non_scoring]=5
				end
				player[:temp_score] += score
			  	puts "Press 1 if you wish to roll the non-scoring #{player[:non_scoring]} dices. Else press 0 :"
				c = gets.chomp

				if c == "1"
					if player[:temp_score] > 0
					  	i = player[:name] 
					end
				elsif c == "0"
					puts "\n"
					if player[:temp_score] >= 300 || player[:fin_score] >= 300
						player[:fin_score] += player[:temp_score] 
					end

					if player[:fin_score] >= 3000 && !@last[:flag]
						@players.each{ |e|
								puts "Player: #{e.player[:name]+1} Score: #{e.player[:fin_score]}"
						}
						puts "Last turn"
						@last = {flag: true, end: i == @players.length}
					end
				end
			end
		end
		if i == player[:name].next
			again(player)
		end
		play(i)
	end

	def again(player)
		player[:non_scoring] = 5 
		player[:temp_score] = 0 
	end

	def initial_start 
		puts "\nEnter the number of players to play:"
		no = gets.chomp
		num_players = no.to_i
		num_players.times { |player|
			@players.push Player.new(player)
		}
		puts "\nTurn 1: \n"
		play(0) 
	end

	def play(i)
		if @last[:end] && i == @players.length 
			i = 0 
			@last_player = 1 
			if @last[:flag]
				@last[:end] = false 
			end
		end
		if i < @players.length-@last_player
			t = @players[i]
			s = t.player
			score = t.roll_dice(s) 
			calculate(score, s)
		else
			puts "\nScores after Turn #{@rnd}: "
			@players.each{ |e|
				puts "Player: #{e.player[:name]+1} Score: #{e.player[:fin_score]}"
			}
			puts ""
			@rnd += 1
			puts "Turn #{@rnd}: \n" if !@last[:flag]
			if !@last[:flag] || @last[:end] 
				play(0) 
			else
				winner = @players.max_by { |player|
				 	player.player[:fin_score]
				}
				puts "\nPlayer #{winner.player[:name]+1} won. Final score is #{winner.player[:fin_score]} \n"
			end
		end
	end 
end


