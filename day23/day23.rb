Cup = Struct.new(:num, :clockwise)

class CrabCupsLarge
  def initialize(cups, total_cups = 9)
    @len = total_cups
    first_num = cups.chars.first.to_i
    @current = Cup.new(first_num)
    @cup_hash = {first_num => @current}
    prev_cup = @current
    cups.chars[1..-1].each{|num| prev_cup = prev_cup.clockwise = @cup_hash[num.to_i] = Cup.new(num.to_i) }
    10.upto(total_cups).each{|num| prev_cup = prev_cup.clockwise = @cup_hash[num] = Cup.new(num) }
    prev_cup.clockwise = @current
  end

  def move
    picks = [@current.clockwise, @current.clockwise.clockwise, @current.clockwise.clockwise.clockwise]
    @current.clockwise = picks.last.clockwise

    label = cur_label = @current.num
    label = next_cup_label(label) until label != cur_label && !picks.map(&:num).include?(label)

    dest = @cup_hash[label]
    #puts "destination: #{label}"
    dest.clockwise, picks.last.clockwise = picks.first, dest.clockwise
    @current = @current.clockwise
  end

  def move_all(num)
    num.times { move }
    if @len < 10
      start = @cup_hash[1]
      8.times.map{ start = start.clockwise; start.num }.join
    else
      @cup_hash[1].clockwise.num * @cup_hash[1].clockwise.clockwise.num
    end
  end

  def next_cup_label(cup)
    cup == 1 ? @len : cup - 1
  end
end

puts "Hopefully 92658374"
puts CrabCupsLarge.new('389125467').move_all(10)

puts "Hopefully 67384529"
puts CrabCupsLarge.new('389125467').move_all(100)

puts "First star"
puts CrabCupsLarge.new('716892543').move_all(100)

puts "Large sample - hopefully 149245887792"
puts CrabCupsLarge.new('389125467', 1000000).move_all(10000000)

puts "Second star"
puts CrabCupsLarge.new('716892543', 1000000).move_all(10000000)
