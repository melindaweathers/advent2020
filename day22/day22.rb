require 'set'
class CrabCombat
  def initialize(filename)
    @player1 = []
    @player2 = []
    @memoized_games = {}
    current_player = @player1
    IO.readlines(filename, chomp: true).each do |line|
      if line == 'Player 2:'
        current_player = @player2
      elsif line.to_i > 0
        current_player << line.to_i
      end
    end
  end

  def play_round(player1, player2)
    p1_card = player1[0]
    p2_card = player2[0]
    new_cards = [p1_card, p2_card].sort.reverse
    if p1_card > p2_card
      [player1[1..-1] + new_cards, player2[1..-1]]
    else
      [player1[1..-1], player2[1..-1] + new_cards]
    end
  end

  def play_game
    @player1, @player2 = play_round(@player1, @player2) while @player1.length > 0 && @player2.length > 0
    score(@player1) + score(@player2)
  end

  def play_recursive_round(player1, player2)
    #puts player1.inspect
    #puts player2.inspect
    p1_card = player1[0]
    p2_card = player2[0]
    #puts "Player 1 plays #{p1_card}"
    #puts "Player 2 plays #{p2_card}"
    if p1_card < player1.length && p2_card < player2.length
      winner, _score = play_recursive_game(player1.slice(1, p1_card), player2.slice(1, p2_card))
    else
      winner = p1_card > p2_card ? :player1 : :player2
    end
    winner == :player1 ? [:player1, player1[1..-1] + [p1_card, p2_card], player2[1..-1]] : [:player2, player1[1..-1], player2[1..-1] + [p2_card, p1_card]]
  end

  def play_recursive_game(player1 = @player1, player2 = @player2)
    score = nil; winner = nil
    previous_cards = Set.new
    loop do
      if previous_cards.include?([player1, player2])
        winner = :player1; score = score(player1); break
      else
        previous_cards.add([player1, player2])
        winner, player1, player2 = play_recursive_round(player1, player2)
        score = score(player1) + score(player2) and break unless player1.length > 0 && player2.length > 0
      end
    end
    [winner, score]
  end

  def score(player)
    player.reverse.map.with_index{|val, idx| val*(idx + 1)}.sum
  end
end

puts CrabCombat.new('sample.txt').play_game
puts CrabCombat.new('input.txt').play_game

puts CrabCombat.new('sample.txt').play_recursive_game
puts CrabCombat.new('sample2.txt').play_recursive_game
puts CrabCombat.new('input.txt').play_recursive_game
