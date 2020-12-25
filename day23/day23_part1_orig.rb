class CrabCups
  def initialize(cups)
    @idx = 0
    @len = cups.length
    @cups = cups.chars.map(&:to_i)
  end

  def move
    label = cur_label = @cups[@idx]
    picks = [@cups[(@idx + 1) % @len], @cups[(@idx + 2) % @len], @cups[(@idx + 3) % @len]]
    @cups.reject!{|num| picks.include?(num)}
    label = next_cup_label(label) until label != cur_label && !picks.include?(label)
    dest = @cups.index(label)
    #puts "destination: #{label}"
    @cups.insert((dest + 1) % @len, *picks)
    @idx = (@cups.index(cur_label) + 1) % @len
  end

  def move_all(num)
    num.times { move }
    idx = @cups.index(1)
    1.upto(@len - 1).map{|num| @cups[(idx + num) % @len]}.join
  end

  def print
    puts @cups.map.with_index{|cup, i| i == @idx ? "(#{cup})" : "#{cup}"}.join(' ')
  end

  def next_cup_label(cup)
    cup == 1 ? 9 : cup - 1
  end
end

puts "Hopefully 92658374"
puts CrabCups.new('389125467').move_all(10)

puts "Hopefully 67384529"
puts CrabCups.new('389125467').move_all(100)

puts "First star"
puts CrabCups.new('716892543').move_all(100)
